require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :mclain do

  desc 'Cleaned the database spreadsheet provided by McLain'
  task clean_file: :environment do

    lines = CSV.read("#{Rails.root}/lib/tasks/database.csv", headers: false)
    headers = lines[0].to_a

    CSV.open("#{Rails.root}/lib/tasks/database2.csv", 'w') do |csv|
      csv << headers
    end

    count_line = 1
    CSV.foreach("#{Rails.root}/lib/tasks/database.csv", headers: true) do |row|
      # Cleaning Georgian contact details
      contact_info = row[2]
      email = ''
      if contact_info
        contact_info.split(' ').each do |word|
          if word.include?('@')
            # removing email from the description field
            email = word
            row[2].gsub!(email,'')
            row[2].gsub!("Email:",'')
            row[2].gsub!("Email-",'')
            row[2].gsub!("Email",'')
          end
        end
      end

      contact_info_en = row[3]
      emails = []
      if contact_info_en
        contact_info_en.split(' ').each do |word|
          if word.include?('@')
            # removing email from the description field
            email = word
            row[3].gsub!(email,'')
            row[3].gsub!("Email:",'')
            row[3].gsub!("Email-",'')
            row[3].gsub!("Email",'')
            row[3].gsub!("Address",'')
            email.gsub!(';','')
            email.gsub!("Email:",'')
            email.gsub!("Email-",'')
            emails << email
          end
        end
      end

      # Write emails in relevant columns (indexes 6, 7 and 8)
      if emails.length <= 3
        col_index = 6
        emails.each do |email|
          row[3].gsub!(email,'')
          row[col_index] = email
          col_index += 1
        end
      end

      # Default latitude longitude
      latitude = 41.44273
      longitude = 45.79102

      address = "#{row[1]}, Georgia"

      full_address_array = row[3].split('|')
      if full_address_array && full_address_array.length > 1
        address = full_address_array[0] + ', ' + address
      end

      geocodes = getGeocodesFromAddress(address)

      if geocodes && !geocodes.empty?
        latitude = geocodes['lat']
        longitude = geocodes['lon']
      end

      row[4] = latitude
      row[5] = longitude

      address_details = row[3].gsub('|','')

      # in case gsub made address_details nil
      if !address_details.nil?
        row[3] = address_details
      end

      CSV.open("#{Rails.root}/lib/tasks/database2.csv", 'a') do |csv|
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

    CSV.foreach("#{Rails.root}/lib/tasks/database2.csv", headers: true) do |row|

      geocode_not_found = (row[4] == '41.44273' && row[5] == '45.79102')

      # Creation of the service location
      loc = Location.new(latitude: row[4].to_f, longitude: row[5].to_f,
                         city: row[1], province: row[1], address: row[3], postal_code: '1234',
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
        loc_georgian.update_attributes(city: row[0], address: row[2], province: row[0], postal_code: '1234')

        ad = Ad.new(title: row[12], description: row[10],
                    benef_age_group: row[21], is_giving: true, anon_email: row[6], anon_email_2: row[7],
                    anon_email_3: row[8], anon_name: row[12], is_username_used: false,
                    legal_form: row[20].downcase, expire_date: '2015-12-31', is_published: true)
        ad.location = loc
        ad.items << Item.first
        ad.categories << Category.first
        if ad.save

          ad_georgian = ad.translations.first
          ad_georgian.update_attributes(title: row[11], description: row[9])

          puts "#{count} done"
        else
          puts "#{count} - #{ad.errors.first[0].to_s} #{ad.errors.first[1]}"
          break
        end
      else
        puts "#{count} - #{loc.errors.first[0].to_s} #{loc.errors.first[1]}"
        break
      end

      count += 1
    end

  end

end
