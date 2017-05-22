require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :dev do
  desc 'Randomly assing service to places, for test purpose'
  task randomize_place_services: :environment do
    services = Service.all
    random_amount = [1,2,3,4,5,6,7]

    Place.all.each{|p|
      p.services = services.sample(random_amount.sample)
    }
  end

  desc 'Randomly assing place to user as favorite, for test purpose'
  task randomize_user_favorite_places: :environment do
    places = Place.all
    random_amount = [1,2,3,4,5,6,7]

    User.all.each{|u|
      u.favorites = places.sample(random_amount.sample)
    }
  end
end
