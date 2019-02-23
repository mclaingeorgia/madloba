class Place < ActiveRecord::Base
  include ActiveModel::Validations
  include Nameable
  include RequiredLocale

  # globalize

    translates :name, :description, :city, :address
    globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :description, :city, :address]
    globalize_validations([:name, :description])
  # associations

    has_many :assets, -> { where(owner_type: 1) }, {foreign_key: :owner_id, class_name: "Asset"}
    accepts_nested_attributes_for :assets, :allow_destroy => true

    # belongs_to :provider

    has_one :provider_place
    has_one :provider, through: :provider_place, source: :provider


    belongs_to :region#, required: true

    has_many :favorite_places
    has_many :favoritors, through: :favorite_places, source: :user

    has_many :place_services
    has_many :services, through: :place_services, source: :service


    has_many :place_tags
    has_many :tags, through: :place_tags, source: :tag

    has_many :place_rates
    has_many :rates, through: :place_rates, source: :user

    has_many :place_ownerships
    has_many :ownership_requests, through: :place_ownerships, source: :user

    has_many :uploads


    attr_accessor :provider_id, :redirect_default

  # callbacks

    after_commit :set_poster
    before_validation :remove_blanks

    def set_poster
      if self.poster_id.nil? && self.assets.count > 0
        update_attributes({poster_id: self.assets.first.id})
      end
      if self.poster_id.present? && self.assets.count == 0
        update_attributes({poster_id: nil })
      end
    end

    def remove_blanks
      emails.reject!(&:blank?)
      phones.reject!(&:blank?)
      websites.reject!(&:blank?)
    end

  # scopes
    scope :only_deleted, -> { where.not(deleted: 0) }
    scope :only_published, -> { where(published: true) }
    scope :only_active, -> { where(deleted: 0) }
    scope :excluding, -> (id) { where.not(id: id) }
    scope :sorted, -> { with_translations(I18n.locale).order(name: :asc) }

    def assets_sorted
      poster_asset = self.get_poster()
      assets_array = assets.to_a

      if poster_asset.present?
        assets_array.delete_if{|d| d.id == poster_asset.id}
        assets_array.unshift(poster_asset)
      end

      assets_array
    end

  # validators

    validates :region_id, presence: true
    validates :provider_id, presence: true
    validates :services, :length => { :minimum => 1 }

    validates :emails, array: { email: true }
    validates :emails, :length => { :maximum => 3 }
    validates :websites, :length => { :maximum => 3 }
    validates :websites, array: { format: { with: URI::regexp } }
    validates :phones, array: { numericality: { only_integer: true }, length: {is: 9} }
    validates :latitude, :longitude, numericality: true, presence: true


  # helpers
    def self.validation_order_list
      [Place.globalize_attribute_names, :services, :emails, :phones, :websites, :tags, :published, :postal_code, :region].flatten
    end

    def destroy_asset(id)
      a = self.assets.find(id)
      if a.present?
        self.assets.delete(a)
        a.delete
        if a.id == self.poster_id
          first = self.assets.first
          self.update_attribute(:poster_id, first.present? ? first.id : nil )
        end
        true
      end
    rescue Exception => e
      false
    end

    def get_domain(url)
      host = nil
      require 'uri'
      url = 'http://' + url unless url.match(/^(https{0,1}:\/\/)/)
      host = URI.parse(url).host.gsub(/^www\./, '')
    ensure
      host
    end
  # getters
    def phone
      phones.join(", ")
    end

    def email
      emails.join(", ")
    end

    def website
      websites.join(", ")
    end

    def address_full
      f = [self.address, self.city]
      f << self.region.name if self.region.present?
      f.reject(&:blank?).join(', ')
    end

    def get_rating
      value = self.class.where(:id=>id).select(:rating).first[:rating]
      self[:rating] = value
      r = rating.to_s.format_number
      r == 0 ? nil : r
    end
    def poster
      poster = self.assets.find_by(id: self.poster_id)
      poster.present? ? poster.image.thumb.url : ActionController::Base.helpers.asset_path("png/missing.png")
    end
    def poster_url
      poster = self.assets.find_by(id: self.poster_id)
      ActionController::Base.helpers.image_url(poster.present? ? poster.image_url(:thumb) : "png/missing.png")
    end
    def get_poster
      self.assets.find_by(id: self.poster_id)
    end

  # filter

    def self.filter(filter, current_user)
      places = only_active.only_published
                .with_translations(I18n.locale)
                .includes(:place_services)
      sql = []
      pars = {}
      if filter[:what].present?
        sql << 'lower(place_translations.name) like :name'
        pars[:name] = "%#{filter[:what].downcase}%"

        sql << 'lower(place_translations.address) like :address'
        pars[:address] = "%#{filter[:what].downcase}%"

        sql << 'lower(place_translations.city) like :city'
        pars[:city] = "%#{filter[:what].downcase}%"

        place_ids = Provider.only_active.with_translations(I18n.locale).where('lower(provider_translations.name) like ?', "%#{filter[:what].downcase}%").includes(:places).pluck('places.id')
        place_ids += Tag.accepted.where('lower(name) like ?', "%#{filter[:what].downcase}%").includes(:places).pluck('places.id')

        sql << 'places.id in (:place_ids)'

        pars[:place_ids] = place_ids.uniq
      end

      # if filter[:where].present?
      #   places = places.where(:region_id => filter[:where])
      # end

      # if filter[:services].present?
      #   places = places.includes(:services).where(:services => { id: filter[:services] })
      # end

      # no longer used as filter
      # if filter[:rate].present?
      #   places = places.where('places.rating > ?', filter[:rate])
      # end

      if filter[:favorite] && current_user.present?
        # place_ids = current_user.favorites.pluck(:place_id)
        # places = places.where(id: place_ids)

        # indicate which places are marked as this users favorites
        places = places.includes(:favorite_places).where(favorite_places: {user_id: current_user.id})
      end

      places.where(sql.join(" OR "), pars).order(name: :asc)
    end

    def self.autocomplete(q, user, related_id)
      provider = Provider.find_by(id: related_id)
      exclude_ids = []
      exclude_ids = provider.places.pluck(:id) if provider.present?
      if user.admin?
        with_translations(I18n.locale).where('lower(place_translations.name) like ?', "%#{q.downcase}%").where.not(id: exclude_ids).pluck(:id, :name).map{|m| { id: m[0], text: m[1]} }
      else
        user.providers.includes(:places).with_translations(I18n.locale).where('lower(place_translations.name) like ?', "%#{q.downcase}%").where.not(id: exclude_ids).pluck(:id, :name).map{|m| { id: m[0], text: m[1]} }
      end
    end

end
