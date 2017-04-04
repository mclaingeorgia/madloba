class Service < ActiveRecord::Base
  translates :name, :description

  belongs_to :places
  # has_and_belongs_to_many :places
end
