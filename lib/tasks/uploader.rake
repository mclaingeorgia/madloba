require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :uploader do

  original_dataset_path = "#{Rails.root}/public/data/dataset.csv"
  cleaned_dataset_path = "#{Rails.root}/public/data/cleaned_dataset.csv"
  missing_dataset_path = "#{Rails.root}/public/data/missing_geocode.csv"

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
        region_id = tmp.id if tmp.present?

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
