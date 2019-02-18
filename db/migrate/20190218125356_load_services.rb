class LoadServices < ActiveRecord::Migration
  def up

    Service.destroy_all

    # load from csv file
    # column order:
    # 0 - en name
    # 1 - en desc
    # 2 - ka name
    # 3 - ka desc
    # 4 - icon
    # 5 - for children
    # 6 - for adult
    # 7 - en parent
    services = CSV.read("#{Rails.root}/public/data/services.csv")
    created_records = []

    services.each_with_index {|item, i|
      puts "------------"
      puts "- row #{i}"
      if i > 0
        d = Service.new(
          name_en: item[0].strip,
          description_en: item[1],
          name_ka: item[2].strip,
          description_ka: item[3],
          icon: item[4],
          for_children: item[5] == 'TRUE',
          for_adults: item[6] == 'TRUE',
        )

        # if this is a child, assign the parent
        if item[7].present?
          parent = created_records.select{|x| x.name_en == item[7].strip}.first
          if parent
            puts "-- adding parent #{parent.id}"
            d.parent_id = parent.id
          else
            puts "-- COULD NOT FIND PARENT #{item[7]}"
          end
        end

        d.save

        created_records << d
      end
    }
  end

  def down
    Service.destroy_all

    services = [
      { icon: 'adult', name: { en: "Adult", ka: "ზრდასრულთა მომსახურება" }, description: { en: "Services offering specialized support and assistance to adults with all types of physical  and intellectual disabilities and/or mental health problems", ka: "სპეციალური სერვისები,რომელიც მიმართულია ყველა ტიპის ფიზიკური და გონებრივი შეზღუდვის მქონე ზრდასრულის მხარდასაჭერად." } },
      { icon: 'children', name: { en: "Children", ka: "სერვისები ბავშვებისათვის" },  description: { en: "Services offering specialized support and assistance to children with physical and/or intellectual disabilities. This may also include support for their parents and/or carers.", ka: "სერვისები მიმართულია ფიზიკური და/ან გონებრივი შეზღუდვების მქონე ბავშვებზე. ასევე ბავშვის მშობლის/მეურვის მხარდაჭერაზე." } },
      { icon: 'education', name: { en: "Education", ka: "ინკლუზიური განათლება" },  description: { en: "Educational facilities offering inclusive education for children and/or adults with all types of disabilities", ka: "საგანმანათლებლო დაწესებულებები, რომლებიც სთავაზობენ ინკლუზიურ განათლებას სხვადასხვა შეზღუდვების მქონე ბავშვებსა და მოზარდებს." } },
      { icon: 'legal', name: { en: "Legal", ka: "სამართლებრივი სერვისები" },  description: { en: "All services and / or organisations dealing with legal aspects of healthcare and rehabilitation, including training and awareness raising", ka: "ორგანიზაციები, რომლებიც მუშაობენ ჯანდაცვის და რეაბილიტაციის სამართლებრივ ასპექტებზე. სერვისები მოიცავს თემისათვის ტრენინგებსა და ცნობიერების ამაღლების აქტივობების განხორციელებას." } },
      { icon: 'health', name: { en: "Health", ka: "სამედიცინო" },  description: { en: "Services offering specialized medical care, surgery and treatment for people of all ages. This also includes funding support for all medical related services.", ka: "სერვისები,რომელიც მოიცავს სპეციალიზირებულ სამედიცინო დახმარებას, როგორიც არის ოპერაცია და მკურნალობა ნებისმიერი ასაკის ადამიანისათვის. აღნიშნულ სერვისში მოიაზრება სამედიცინო სერვისების დაფინანსებაც." } },
      { icon: 'rehab', name: { en: "Rehabilitation/Habitation", ka: "ფიზიკური რეაბილიტაცია" }, description: { en: "All types of physical rehabilitation and therapy services", ka: "ყველა ტიპის ფიზიკური რეაბილიტაცია და თერაპიული სერვისი" } },
      { icon: 'other', name: { en: "Other Services", ka: "სხვა სერვისები" }, description: { en: "Services that are not clearly defined by already established Service Categories", ka: "ის სერვისები,რომელიც არ შეესაბამება არცერთ არსებულ სერვისის კატეგორიას." } },
      { icon: 'social', name: { en: "Social Benefits", ka: "სოციალური დახმარება" },  description: { en: "Inclusive social groups, activities and/or support services for children and adults", ka: "სოციალური დახმარების პროგრამები ბავშვებისა და მოზრდილებისათვის" } }
    ]

    services.each {|item|
      d = Service.create(icon: item[:icon])
      I18n.available_locales.each { |locale|
        Globalize.with_locale(locale) do
          d.update_attributes(:name => item[:name][locale], :description => item[:description][locale])
        end
      }
    }

  end
end
