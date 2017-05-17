class Place < ActiveRecord::Base
  translates :name, :description, :city, :address
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :description, :city, :address]

  belongs_to :provider


  has_one :provider_place
  has_one :provider, through: :provider_place, source: :provider


  has_one :region

  has_many :user_places
  has_many :favoriting_users, through: :user_places, source: :user

  has_many :place_services
  has_many :services, through: :place_services, source: :service

  has_many :assets

  has_many :place_tags
  has_many :tags, through: :place_tags, source: :tag


  def self.authorized_by_id(id)
    all.find(id)
  end

  def phone
    phones.join(", ")
  end

  def email
    emails.join(", ")
  end

  def self.by_filter(filter)
    places = nil
    # Rails.logger.debug("--------------------------------------------#{with_translations(I18n.locale).where("place_translations.name like ?", "%#{filter[:what]}%").to_sql}")
    places = with_translations(I18n.locale)
    sql = []
    pars = {}
    if filter[:what].present?
      places = places.where('name like ?', "%#{filter[:what]}%")
    end
    if filter[:where].present?
      sql << 'address like :address'
      pars[:address] = "%#{filter[:where]}%"
      sql << 'city like :city'
      pars[:city] = "%#{filter[:where]}%"
    end

    if filter[:services].present?
      places = places.includes(:services).where(:services => { id: filter[:services] })
    end

    if filter[:rate].present?
      places = places.where('rating > ?', filter[:rate])
    end

     Rails.logger.debug("--------------------------------------------#{places.where(sql.join(" OR "), pars).to_sql}")
    # what=blah&where=32s&favorite=true&map[]=1&map[]=2&map[]=3&services[]=67&services[]=68
    places.where(sql.join(" OR "), pars)
  end

end
