class ProviderUser < ActiveRecord::Base
  belongs_to :provider
  belongs_to :user
end
