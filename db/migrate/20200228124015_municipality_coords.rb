class MunicipalityCoords < ActiveRecord::Migration
  def up
    add_column :municipalities, :latitude, :decimal, precision: 8, scale: 5, default: 41.44273
    add_column :municipalities, :longitude, :decimal, precision: 8, scale: 5, default: 41.44273

    # update existing values
    Municipality.transaction do
      munis = Municipality.all

      coords = CSV.read("#{Rails.root}/db/data/municipalities.csv")

      I18n.locale = :en

      if munis && coords
        munis.each do |muni|
          puts muni.name

          # look for match
          coord = coords.select{|x| x[1] == muni.name}.first

          if coord
            puts "- found coords, saving"
            muni.latitude = coord[2]
            muni.longitude = coord[3]
            muni.save
          end
        end
      end
    end
  end

  def down
    remove_column :municipalities, :latitude
    remove_column :municipalities, :longitude
  end
end
