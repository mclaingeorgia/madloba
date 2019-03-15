class AddNewPlaceServiceFields < ActiveRecord::Migration
  def change
    add_column :place_services, :is_restricited_geographic_area, :boolean
    add_column :place_services, :geographic_area_municipalities, :integer, array: true, default: [], null: false
    add_column :place_services, :service_type, :integer, array: true, default: [], null: false
    add_column :place_services, :act_regulating_service, :string
    add_column :place_services, :act_link, :string
    add_column :place_services, :description, :text
    add_column :place_services, :has_age_restriction, :boolean
    add_column :place_services, :age_groups, :integer, array: true, default: [], null: false
    add_column :place_services, :can_be_used_by, :integer
    add_column :place_services, :diagnoses, :string, array: true, default: [], null: false
    add_column :place_services, :service_activities, :string, array: true, default: [], null: false
    add_column :place_services, :service_specialists, :string, array: true, default: [], null: false
    add_column :place_services, :need_finance, :boolean
    add_column :place_services, :get_involved_link, :string

    add_index :place_services, :geographic_area_municipalities
    add_index :place_services, :has_age_restriction
    add_index :place_services, :age_groups

  end
end
