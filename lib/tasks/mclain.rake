namespace :mclain do

  desc 'Cleaned the database spreadsheet provided by McLain'
  task clean_file: :environment do

    lines = CSV.read("#{Rails.root}/lib/tasks/database.csv", headers: false)
    headers = lines[0].to_a

    CSV.open("#{Rails.root}/lib/tasks/database2.csv", 'w') do |csv|
      csv << headers
    end

    CSV.foreach("#{Rails.root}/lib/tasks/database.csv", headers: true) do |row|
      contact_info = row[3]
      email = ''
      if contact_info
        contact_info.split(' ').each do |word|
          if word.include?('@')
            email = word
            break
          end
        end
      end
      # removing email from the description field
      if row[3]
        row[3].gsub!(email,'')
      end
      if row[5]
        row[5].gsub!(email,'')
      end
      # cleaning up email addresses
      if email
        email.gsub!('.com.','.com')
      end
      row[4] = email

      CSV.open("#{Rails.root}/lib/tasks/database2.csv", 'a') do |csv|
        csv << row
      end
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

    CSV.foreach("#{Rails.root}/lib/tasks/database2.csv", headers: true) do |row|
      latitude = 41.95132
      longitude = 43.35394

      loc = Location.new(latitude: latitude, longitude: longitude, city: 'Tbilisi', province: row[2], address: row[5], postal_code: '1234', loc_type: 'exact')
      loc.save

      ad = Ad.new(title: "Service #{count}", description: row[7], funding_source: row[11].downcase.gsub(' ',''), is_parental_support: (row[15] == 'implements'),
                  benef_age_group: row[17], is_giving: true, anon_email: row[4], anon_name: row[9], is_username_used: false)
      ad.location = loc
      ad.items << Item.first
      ad.save

      count += 1
    end

  end

end
