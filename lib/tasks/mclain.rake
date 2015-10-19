require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :mclain do

  desc 'Cleaned the database spreadsheet provided by McLain'
  task clean_file: :environment do

    lines = CSV.read("#{Rails.root}/lib/tasks/database4.csv", headers: false)
    headers = lines[0].to_a

    CSV.open("#{Rails.root}/lib/tasks/database5.csv", 'w') do |csv|
      csv << headers
    end

    count_line = 1
    CSV.foreach("#{Rails.root}/lib/tasks/database4.csv", headers: true) do |row|
      # Cleaning Georgian contact details

      geocode_not_found = (row[30] == '41.44273' && row[31] == '45.79102')

      if geocode_not_found
        # Default latitude longitude
        latitude = 41.44273
        longitude = 45.79102

        region = row[1]
        street_number = row[3]
        street_name = row[7]
        #if street_name
        #if !street_name.split(' ').last == 'Avenue'
        #street_name += ' street'
        #end
        #end

        village = row[11]
        city = row[9]

        address = ''
        if village && village.present?
          address = "#{street_number} #{street_name}, #{village}, #{city}, #{region}, Georgia"
        else
          address = "#{street_number} #{street_name}, #{city}, #{region}, Georgia"
        end


        #full_address_array = row[3].split('|')
        #if full_address_array && full_address_array.length > 1
        #address = full_address_array[0] + ', ' + address
        #end

        geocodes = getGeocodesFromAddress(address)

        if geocodes && !geocodes.empty?
          latitude = geocodes['lat']
          longitude = geocodes['lon']
        else
          if village && village.present?
            address = "#{street_name}, #{village}, #{city}, #{region}, Georgia"
          else
            address = "#{street_name}, #{city}, #{region}, Georgia"
          end
          geocodes = getGeocodesFromAddress(address)
          if geocodes && !geocodes.empty?
            latitude = geocodes['lat']
            longitude = geocodes['lon']
          end
        end

        row[30] = latitude
        row[31] = longitude
      end

      CSV.open("#{Rails.root}/lib/tasks/database5.csv", 'a') do |csv|
        csv << row
      end
      puts count_line
      count_line += 1
    end
  end

  desc 'Imports data from the cleaned CSV file'
  task import_data: :environment do
    count = 1

    # Necessity to create at least one item, in otder to create the ads successfully.
    if Item.all.count == 0
      i = Item.new(name: 'default item', category: Category.first)
      i.save
    end

    CSV.open("#{Rails.root}/lib/tasks/database_geo_missing.csv", 'w') do |csv|
      csv << ['id', 'city', 'address']
    end

    CSV.foreach("#{Rails.root}/lib/tasks/database5.csv", headers: true) do |row|

      geocode_not_found = (row[30] == '41.44273' && row[31] == '45.79102')

      phone_numbers = row[15]
      phone_number = ''
      add_phone_number = ''
      add_phone_number_2 = ''
      if phone_numbers
        phone_numbers.gsub!(' ','')
        pn_array = phone_numbers.split('|')
        phone_number = pn_array[0] if pn_array.length > 0
        add_phone_number = pn_array[1] if pn_array.length > 1
        add_phone_number_2 = pn_array[2] if pn_array.length > 2
      end

      # Creation of the service location
      loc = Location.new(latitude: row[30].to_f, longitude: row[31].to_f,
                         city: row[9], province: row[1], address: row[7], postal_code: '1234',
                         village: row[11], block_unit: row[5], phone_number: phone_number,
                         add_phone_number: add_phone_number, add_phone_number_2: add_phone_number_2,
                         loc_type: 'exact')


      if loc.save
        if geocode_not_found
          # Tracking the locations which geocodes could not be found.
          CSV.open("#{Rails.root}/lib/tasks/database_geo_missing.csv", 'a') do |csv|
            csv << [loc.id.to_s, row[1], row[3]]
          end
        end

        # Adding translations
        loc_georgian = loc.translations.first
        loc_georgian.update_attributes(city: row[8], address: row[6],
                                       province: row[0], postal_code: ' ',
                                       village: row[10], block_unit: row[4])

        emails = row[13]
        email = ''
        email2 = ''
        email3 = ''
        if emails
          emails.gsub!(' ','')
          em_array = emails.split('|')
          email = em_array[0] if em_array.length > 0
          email2 = em_array[1] if em_array.length > 1
          email3 = em_array[2] if em_array.length > 2
        end

        # Creating ads.
        ad = Ad.new(title: row[19], description: row[17],
                    benef_age_group: row[29], is_giving: true, anon_email: email, anon_email_2: email2,
                    anon_email_3: email3, anon_name: row[19], is_username_used: false,
                    legal_form: row[27].downcase, expire_date: '2015-12-31', is_published: true)

        ad.location = loc
        ad.items << Item.first
        ad.categories << Category.first

        if ad.save

          ad_georgian = ad.translations.first
          ad_georgian.update_attributes(title: row[18], description: row[16])

          puts "#{count} done"
        else
          puts "#{count} - #{row[19]} - #{ad.errors.first[0].to_s} #{ad.errors.first[1]}"
          break
        end
      else
        puts "#{count} - loc - #{loc.errors.first[0].to_s} #{loc.errors.first[1]}"
        break
      end

      count += 1
    end

  end

end
