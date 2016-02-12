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
        village = row[11]
        city = row[9]

        address = ''
        if village && village.present?
          address = "#{street_number} #{street_name}, #{village}, #{city}, #{region}, Georgia"
        else
          address = "#{street_number} #{street_name}, #{city}, #{region}, Georgia"
        end

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

  task update_data: :environment do

    count = 1

    CSV.foreach("#{Rails.root}/lib/tasks/database5.csv", headers: true) do |row|

      id = 296 + count
      loc = Location.find(id)

      if loc.present?
        I18n.locale = :en
        loc.update_attributes(city: row[9], province: row[1], address: row[7], village: row[11], block_unit: row[5])

        I18n.locale = :ka
        loc.update_attributes(city: row[8], address: row[6], province: row[0], postal_code: '1234', village: row[10], block_unit: row[4])

        puts 'loc updated'

        ad = Ad.where(location: loc.id).first

        if ad.present?
          I18n.locale = :en
          ad.update_attributes(title: row[19], description: row[17])

          I18n.locale = :ka
          ad.update_attributes(title: row[18], description: row[16])
          puts 'ad updated'
        end
      end

      puts count
      count += 1

    end
    
  end

  desc 'Generates users'
  task generate_users: :environment do

    CSV.open("#{Rails.root}/lib/tasks/user_password.csv", 'w') do |csv|
      csv << ['email','password']
    end

    anon_emails = Ad.where("anon_email != ''").pluck(:anon_email).uniq
    count = 1

    anon_emails.each do |email|
      generated_password = Array.new(12){rand(36).to_s(36)}.join

      username = email.split('@')[0]

      @user = User.new(email: email, password: generated_password, password_confirmation: generated_password,
                       username: username, is_service_provider: true)

      @user.confirmation_token = nil
      @user.confirmed_at = Time.now
      @user.has_agreed_to_tos = true
      @user.save

      if @user.errors.present?
        puts "#{email}' with password '#{generated_password}: #{@user.errors.as_json}"
      end

      CSV.open("#{Rails.root}/lib/tasks/user_password.csv", 'a') do |csv|
        csv << [email,generated_password]
      end

      #puts "Generated '#{email}' with password '#{generated_password}'"
      count += 1
    end

    puts "Transfering locations to users now (#{Location.all.count})..."

    count = 1
    Location.all.each do |location|
      loc_ad = location.ads.first
      if loc_ad.present?
        if loc_ad.anon_email != ''
          user = User.find_by_email(loc_ad.anon_email)
          if user.present?
            user.locations << location
            user.save

            loc_ad.user = user
            loc_ad.save
          end
        end
      end

      #puts count
      count += 1
    end

    puts 'All done.'

  end
end
