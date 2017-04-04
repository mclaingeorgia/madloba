class Moderation < ActiveRecord::Base
  TYPES = [:report, :take_ownership, :new_provider, :place_tags]
end
