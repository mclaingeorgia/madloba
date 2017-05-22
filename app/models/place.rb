class Place < ActiveRecord::Base
  translates :name, :description, :city, :address
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :description, :city, :address]

  belongs_to :provider


  has_one :provider_place
  has_one :provider, through: :provider_place, source: :provider


  has_one :region#, required: true

  has_many :favorite_places
  has_many :favoritors, through: :favorite_places, source: :user

  has_many :place_services
  has_many :services, through: :place_services, source: :service

  has_many :assets

  has_many :place_tags
  has_many :tags, through: :place_tags, source: :tag


  has_many :place_rates
  has_many :rates, through: :place_rates, source: :user

  has_many :place_ownerships
  has_many :ownership_requests, through: :place_ownerships, source: :user


  # def self.authorized_by_id(id)
  #   all.find(id)
  # end

  def phone
    phones.join(", ")
  end

  def email
    emails.join(", ")
  end

  def get_rating
    rating.to_s.format_number
  end
  def self.by_filter(filter, current_user)
    places = with_translations(I18n.locale)
    sql = []
    pars = {}
    if filter[:what].present?
      sql << 'lower(place_translations.name) like :name'
      pars[:name] = "%#{filter[:what].downcase}%"

      place_ids = Provider.with_translations(I18n.locale).where('lower(provider_translations.name) like ?', "%#{filter[:what].downcase}%").includes(:places).pluck('places.id')

      sql << 'places.id in (:place_ids)'
      pars[:place_ids] = place_ids
    end
    if filter[:where].present?
      sql << 'lower(place_translations.address) like :address'
      pars[:address] = "%#{filter[:where].downcase}%"
      sql << 'lower(place_translations.city) like :city'
      pars[:city] = "%#{filter[:where].downcase}%"
    end

    if filter[:services].present?
      places = places.includes(:services).where(:services => { id: filter[:services] })
    end

    if filter[:rate].present?
      places = places.where('places.rating > ?', filter[:rate])
    end

    if filter[:favorite] && current_user.present?
      place_ids = current_user.favorites.pluck(:place_id)
      places = places.where(id: place_ids)
    end

    places.where(sql.join(" OR "), pars)
  end


end
