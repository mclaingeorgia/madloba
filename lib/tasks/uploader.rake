require "#{Rails.root}/app/helpers/application_helper"
# preload helpers and data

  include ApplicationHelper
  cities = [
    { ka: "თბილისი", en: "Tbilisi"},
    { ka: "ბათუმი", en: "Batumi"},
    { ka: "ქუთაისი", en: "Kutaisi"},
    { ka: "რუსთავი", en: "Rustavi"},
    { ka: "გორი", en: "Gori"},
    { ka: "ზუგდიდი", en: "Zugdidi"},
    { ka: "ფოთი", en: "Poti"},
    { ka: "ხაშური", en: "Khashuri"},
    { ka: "სამტრედია", en: "Samtredia"},
    { ka: "სენაკი", en: "Senaki"},
    { ka: "ზესტაფონი", en: "Zestafoni"},
    { ka: "მარნეული", en: "Marneuli"},
    { ka: "თელავი", en: "Telavi"},
    { ka: "ახალციხე", en: "Akhaltsikhe"},
    { ka: "ქობულეთი", en: "Kobuleti"},
    { ka: "ოზურგეთი", en: "Ozurgeti"},
    { ka: "კასპი", en: "Kaspi"},
    { ka: "ჭიათურა", en: "Chiatura"},
    { ka: "წყალტუბო", en: "Tsqaltubo"},
    { ka: "საგარეჯო", en: "Sagarejo"},
    { ka: "გარდაბანი", en: "Gardabani"},
    { ka: "ბორჯომი", en: "Borjomi"},
    { ka: "ტყიბული", en: "Tqibuli"},
    { ka: "ხონი", en: "Khoni"},
    { ka: "ბოლნისი", en: "Bolnisi"},
    { ka: "ახალქალაქი", en: "Akhalkalaki"},
    { ka: "გურჯაანი", en: "Gurjaani"},
    { ka: "მცხეთა", en: "Mtskheta"},
    { ka: "ყვარელი", en: "Qvareli"},
    { ka: "ახმეტა", en: "Akhmeta"},
    { ka: "ქარელი", en: "Kareli"},
    { ka: "ლანჩხუთი", en: "Lanchkhuti"},
    { ka: "წალენჯიხა", en: "Tsalenjikha"},
    { ka: "დუშეთი", en: "Dusheti"},
    { ka: "საჩხერე", en: "Sachkhere"},
    { ka: "დედოფლისწყარო", en: "Dedoplistsqaro"},
    { ka: "ლაგოდეხი", en: "Lagodekhi"},
    { ka: "ნინოწმინდა", en: "Ninotsminda"},
    { ka: "აბაშა", en: "Abasha"},
    { ka: "წნორი", en: "Tsnori"},
    { ka: "თერჯოლა", en: "Terjola"},
    { ka: "მარტვილი", en: "Martvili"},
    { ka: "ჯვარი", en: "Jvari"},
    { ka: "ხობი", en: "Khobi"},
    { ka: "ვანი", en: "Vani"},
    { ka: "ბაღდათი", en: "Baghdati"},
    { ka: "ვალე", en: "Vale"},
    { ka: "თეთრი წყარო", en: "Tetritsqaro"},
    { ka: "წალკა", en: "Tsalka"},
    { ka: "დმანისი", en: "Dmanisi"},
    { ka: "ონი", en: "Oni"},
    { ka: "ამბროლაური", en: "Ambrolauri"},
    { ka: "სიღნაღი", en: "Sighnaghi"},
    { ka: "ცაგერი", en: "Tsageri"},
    { ka: "ჩოხატაური", en: "Chokhatauri"},
    { ka: "ხარაგაული", en: "Kharagauli"}
  ]

  LANG_MAP_TO_GEO = { 'a'   => ['ა'],
                    'b'   => ['ბ'],
                    'g'   => ['გ'],
                    'd'   => ['დ'],
                    'e'   => ['ე'],
                    'v'   => ['ვ'],
                    'z'   => ['ზ'],
                    'i'   => ['ი'],
                    'l'   => ['ლ'],
                    'm'   => ['მ'],
                    'n'   => ['ნ'],
                    'o'   => ['ო'],
                    'zh'  => ['ჟ'],
                    'r'   => ['რ'],
                    's'   => ['ს'],
                    't'   => ['ტ','თ'],
                    'u'   => ['უ'],
                    'p'   => ['პ','ფ'],
                    'k'   => ['კ','ყ'],
                    'gh'  => ['ღ'],
                    'q'   => ['ქ'],
                    'sh'  => ['შ'],
                    'dz'  => ['ძ'],
                    'ts'  => ['ც','წ'],
                    'ch'  => ['ჩ','ჭ'],
                    'kh'  => ['ხ'],
                    'j'   => ['ჯ'],
                    'h'   => ['ჰ']  }

  def latinize(str)
    new_string = String.new(str)
    LANG_MAP_TO_GEO.each do |latin, georgian|
      georgian.each do |ge|
        new_string.gsub!(ge,latin)
      end
    end
    new_string
  end

  def clean_street_name(str)
    str.nil? ? ''
    : str.gsub('N', '')
        .gsub('ქ. თბილისი.', '')
        .gsub('ქ.', '')
        .gsub('#', '')
        .gsub('№', '')
  end


namespace :uploader do

  original_dataset_path = "#{Rails.root}/public/data/uploader/dataset.csv"
  cleaned_dataset_path = "#{Rails.root}/public/data/uploader/cleaned_dataset.csv"
  missing_dataset_path = "#{Rails.root}/public/data/uploader/missing_geocode.csv"


  desc 'Clean spreadsheet data, public/data/dataset.csv'
  task clean_data: :environment do


    row_index = 0
    CSV.open(cleaned_dataset_path, 'w', {force_quotes: true}) do |to_csv|
      CSV.foreach(original_dataset_path) do |row|
        unless row_index == 0
          unless row[30].present? && row[30] != '41.44273' && row[31].present? && row[31] != '45.79102'
            coordinate = ['41.44273', '45.79102'] # Default latitude longitude

            address_lookups = assemble_address({
              street_number: row[3],
              street_name: row[7],
              village: row[11],
              city: row[9],
              region: row[1]
            })
            address_lookups.each {|address|
              geocodes = geocodes_from_address(address)
              if geocodes.present?
                coordinate = geocodes
                break
              end
            }
            row[30],row[31] = coordinate
          end
        end
        to_csv << row
        row_index+=1
        puts row_index if row_index % 50 == 0
        # break if row_index > 3
      end
    end
  end

  desc 'Imports data from the cleaned CSV file'
  task import_data: :environment do
    Provider.destroy_all
    Place.destroy_all
    other_service = Service.with_translations(:ka).find_by(name: 'სხვა სერვისები')
    CSV.open(missing_dataset_path, 'w') do |csv|
      csv << ['id', 'city', 'address']
    end

    row_index = 1
    CSV.foreach(cleaned_dataset_path, headers: true) do |row, row_i|

      template = { name: { en: clean_string_from_spaces(row[19]), ka: clean_string_from_spaces(row[18]) },
        description: { en: clean_string_from_spaces(row[17]), ka: clean_string_from_spaces(row[16]) } }

      template.keys.each{|key|
        template[key][:ka] = template[key][:en] if template[key][:ka].empty? && template[key][:en].present?
        template[key][:en] = template[key][:ka] if template[key][:en].empty? && template[key][:ka].present?
        if template[key][:en].empty? && template[key][:ka].empty?
          template[key][:en] = 'dummy'
          template[key][:ka] = 'dummy'
        end
      }
      p = nil
      is_new = false
      Globalize.with_locale(:ka) do
        p = Provider.find_by({name: template[:name][:ka], description: template[:description][:ka]})
        unless p.present?
          p = Provider.create({name: template[:name][:ka], description: template[:description][:ka]})
          is_new = p.present? && !p.new_record?
        end

      end
      if is_new
        Globalize.with_locale(:en) do
          p.update_attributes({name: template[:name][:en], description: template[:description][:en]})
        end
      end

      if p.new_record?
        puts row_index
        puts template.inspect
      else
        region = row[0].strip.gsub(' -', '-').gsub('- ', '-')
        region = 'რაჭა-ლეჩხუმი და ქვემო სვანეთი' if region == 'რაჭა-ლეჩხუმი-ქვემო სვანეთი'
        region_id = nil
        tmp = Region.with_translations(:ka).find_by(name: region)
        region_id = tmp.present? ? tmp.id : Region.find_by(name: 'თბილისი').id

        puts "#{row_index} - #{region}" if region_id.nil?

        # end
        place = {
          phones: row[15].gsub(' ', '').split('|'),
          emails: row[13].gsub(' ', '').split('|'),
          latitude: row[30].to_f,
          longitude: row[31].to_f,
          region_id: region_id,
          name: template[:name][:ka],
          description: template[:description][:ka],
          address: [row[4], row[2], row[6], row[10]].map{|m| clean_string(m) }.reject { |c| c.empty? }.join(', '),
          city: row[8].squeeze(' ').strip,
          services: [other_service],
          published: true
        }

        # tmp = Region.with_translations(:ka).find_by(name: region)

        pl = nil
        Globalize.with_locale(:ka) do
          pl = Place.new(place)
          pl.save(:validate => false)
          # puts other_service.inspect
          # pl.services << other_service
          # puts pl.errors.inspect
          p.places << pl
        end

        if !pl.new_record?
          Globalize.with_locale(:en) do
            pl.update_attributes({
              name: template[:name][:en],
              description: template[:description][:en],
              address: [row[5], row[3], row[7], row[11]].map{|m| clean_string(m) }.reject { |c| c.empty? }.join(', '),
              city: row[9].squeeze(' ').strip,
              provider_id: p.id
            })
          end
        end

        geocode_not_found = (place[:latitude] == 41.44273 && place[:longitude] == 45.79102)
        if geocode_not_found
          # Tracking the locations which geocodes could not be found.
          CSV.open(missing_dataset_path, 'a') do |csv|
            csv << [pl.id.to_s, row[1], row[3]]
          end
        end
      end
      row_index += 1

      # break if row_index > 3
    end
  end

end

namespace :uploader_v2 do

  original_dataset_path = "#{Rails.root}/public/data/uploader_v1/dataset.csv"
  cleaned_dataset_path = "#{Rails.root}/public/data/uploader_v1/cleaned_dataset.csv"
  missing_dataset_path = "#{Rails.root}/public/data/uploader_v1/missing_geocode.csv"

  desc 'Clean spreadsheet data, public/data/uploader_v1/dataset.csv'
  task clean_data: :environment do


    row_index = 0
    CSV.open(cleaned_dataset_path, 'w', {force_quotes: true}) do |to_csv|
      CSV.foreach(original_dataset_path) do |row|
        unless row_index == 0
          unless row[15].present? && row[15] != '41.44273' && row[16].present? && row[16] != '45.79102'
            coordinate = ['41.44273', '45.79102'] # Default latitude longitude
            row[17] = clean_street_name(row[14])
            address_lookups = assemble_address({
              street_name: row[17],
              city: row[13]
            }.merge(row[12] != row[13] ? { region: row[12] } : {}))
            address_lookups.shift
            row[18] = address_lookups[0]
            address_lookups.each {|address|
              geocodes = geocodes_from_address(address)
              if geocodes.present?
                coordinate = geocodes
                break
              end
            }
            row[15],row[16] = coordinate
          end
        end
        to_csv << row
        row_index+=1
        puts row_index if row_index % 50 == 0
        # break if row_index > 3
      end
    end
  end

  desc 'Imports data from the cleaned CSV file'
  task import_data: :environment do
    Provider.destroy_all
    Place.destroy_all

    child_services = Service.with_translations(:ka).where.not(ancestry: nil)
    # include services that do not have child services
    child_services += Service.with_translations(:ka).where.not(id: Service.where.not(ancestry:nil).pluck(:ancestry).uniq).where(ancestry: nil)

    CSV.open(missing_dataset_path, 'w') do |csv|
      csv << ['id', 'city', 'address']
    end

    row_index = 1
    CSV.foreach(cleaned_dataset_path, headers: true) do |row, row_i|

      provider_name_ka = clean_string_from_spaces(row[2])
      provider_name_en = clean_string_from_spaces(row[1])

      if provider_name_ka.empty?
        puts "Provider name can't be blank, line #{row_i}"
        break
      end

      provider_name_en = latinize(provider_name_ka) if provider_name_en.empty?

      p = nil
      is_new = false
      Globalize.with_locale(:ka) do
        p = Provider.find_by({name: provider_name_ka})
        unless p.present?
          p = Provider.new({name: provider_name_ka})
          p.save(:validate => false)
          is_new = true
        end

      end

      if is_new
        Globalize.with_locale(:en) do
          p.update_attribute(:name,  provider_name_en)
        end
      end

      # if p.new_record?
      #   puts row_index
      #   puts provider_name_ka
      # else

        region = row[12].strip.gsub(' -', '-').gsub('- ', '-')
        region = 'რაჭა-ლეჩხუმი და ქვემო სვანეთი' if region == 'რაჭა-ლეჩხუმი'
        region = 'ქვემო ქართლი' if region == 'ქვემო-ქართლი'
        region = 'სამეგრელო-ზემო სვანეთი' if region == 'სამეგრელო'
        region_id = nil
        tmp = Region.with_translations(:ka).find_by(name: region)
        region_id = tmp.present? ? tmp.id : Region.find_by(name: 'თბილისი').id

        # puts "#{row_index} - #{region}" if region_id.nil?

        place_ages = row[4].split(';').map{|m| m.strip}.select{|f|
          f.index(/[a-z]/i).nil?
        }
        place_children = place_ages.include?('სერვისები ბავშვებისათვის')
        place_adults = place_ages.include?('ზრდასრულთა მომსახურება')

        city = row[13].squeeze(' ').strip
        c = cities.select{|s| s[:ka] == city }
        city_en = c.present? ? c[0][:en] : city

        place_name_ka = ''
        place_name_en = ''
        place_name = row[5]
        if !place_name.empty?
          place_names = place_name.split('/')


          if place_names.length >= 1
            tmp = clean_string_from_spaces(place_names[0])
            place_name_ka = tmp.index(city).present? ? tmp : "#{city} #{tmp}"
          end

          if place_names.length == 2
            tmp = clean_string_from_spaces(place_names[1])
            place_name_en = tmp.index(city_en).present? ? tmp : "#{city_en} #{tmp}"
          end

          if place_names.length > 2
            puts "Place names length should be <= 2, line #{row_i}"
            break
          end
        else
          place_name_ka = provider_name_ka
          place_name_en = provider_name_en
        end

        place_name_en = latinize(place_name_ka) unless place_name_en.present?
        place = {
          phones: row[11].gsub(' ', '').gsub('-', '').gsub('"', '').gsub('.', '').gsub(',', '').chomp(';').split(';'),
          emails: row[10].gsub(' ', '').split(';'),
          websites: row[9].gsub(' ', '').split(';'),
          latitude: row[15].to_f,
          longitude: row[16].to_f,
          region_id: region_id,
          name: place_name_ka,
          address: row[17],
          city: city,
          for_children: place_children,
          for_adults: place_adults,
          services: child_services.sample(Random.new.rand(5)+1),
          published: true
        }

        pl = nil
        Globalize.with_locale(:ka) do
          pl = Place.new(place)
          pl.save(:validate => false)
          # puts other_service.inspect
          # pl.services << other_service
          # puts pl.errors.inspect
          p.places << pl
        end


        if !pl.new_record?
          Globalize.with_locale(:en) do
            pl.name = place_name_en
            pl.address = latinize(row[17])
            pl.city = city_en
            pl.provider_id = p.id
            pl.save(:validate => false)
          end
        end

        geocode_not_found = (place[:latitude] == 41.44273 && place[:longitude] == 45.79102)
        if geocode_not_found
          # Tracking the locations which geocodes could not be found.
          CSV.open(missing_dataset_path, 'a') do |csv|
            csv << [pl.id.to_s, row[2], row[17]]
          end
        end
      # end
      row_index += 1

      # break if row_index > 3
    end
  end

end


