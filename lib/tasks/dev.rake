require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :dev do
  desc 'Randomly assign service to places, for test purpose'
  task randomize_place_services: :environment do
    services = Service.all
    random_amount = [1,2,3,4,5,6,7]

    Place.all.each{|p|
      p.services = services.sample(random_amount.sample)
    }
  end

  desc 'Randomly assign place to user as favorite, for test purpose'
  task randomize_user_favorite_places: :environment do
    places = Place.all
    random_amount = [1,2,3,4,5,6,7]

    User.all.each{|u|
      u.favorites = places.sample(random_amount.sample)
    }
  end

  desc 'Randomly assign rating to place for user , for test purpose'
  task randomize_user_place_rating: :environment do
    places = Place.all
    random_amount = [1,2,3,4,5,6,7]

    User.all.each{|u|
      pls = places.sample(random_amount.sample)
      pls.each {|p|
        PlaceRate.rate(u.id, p.id, [1,2,3,4,5].sample)
      }
    }
  end
end
