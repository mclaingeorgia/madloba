require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :dev do

  desc 'Randomly assing service to places, for test purpose'
  task randomize_place_services: :environment do
    services = Service.all
    random_amount = [1,2,3]

    Place.all.each{|p|
      p.services = services.sample(random_amount.sample)
    }
  end
end
