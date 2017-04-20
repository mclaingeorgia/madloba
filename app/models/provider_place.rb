class ProviderPlace < ActiveRecord::Base
  belongs_to :provider
  belongs_to :place
end
