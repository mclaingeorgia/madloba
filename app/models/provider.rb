class Provider < ActiveRecord::Base
  translates :name, :description
  globalize_accessors :locales => [:en, :ka], :attributes => [:name, :description]

  has_many :provider_users
  has_many :users, through: :provider_users

  has_many :places

  def self.by_user(user_id)
    joins(:users).where(:users => { :id => user_id})#.includes(:places)
  end
end
