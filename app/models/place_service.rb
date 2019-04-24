# == Schema Information
#
# Table name: place_services
#
#  id                             :integer          not null, primary key
#  place_id                       :integer          not null
#  service_id                     :integer          not null
#  created_at                     :datetime
#  updated_at                     :datetime
#  is_restricited_geographic_area :boolean
#  geographic_area_municipalities :integer          default([]), not null, is an Array
#  service_type                   :integer          default([]), not null, is an Array
#  act_regulating_service         :string
#  act_link                       :string
#  description                    :text
#  has_age_restriction            :boolean
#  age_groups                     :integer          default([]), not null, is an Array
#  can_be_used_by                 :integer
#  diagnoses                      :string           default([]), not null, is an Array
#  service_activities             :string           default([]), not null, is an Array
#  service_specialists            :string           default([]), not null, is an Array
#  need_finance                   :boolean
#  get_involved_link              :string
#  published                      :boolean          default(FALSE)
#  deleted                        :integer          default(0)
#

class PlaceService < ActiveRecord::Base
  include ActiveModel::Validations
  include Nameable

  # associations
    belongs_to :place
    belongs_to :service

  # enums
    SERVICE_TYPES = {"municipal": 1, "state": 2, "private_org": 3}
    AGE_GROUPS = {"0-6": 1, "7-18": 2, "18-65": 3, "65+": 4}
    CAN_BE_USED_BY = {"anyone": 1, "diagnosis_with_status": 2, "diagnosis_without_status": 3}
    enum can_be_used_by: CAN_BE_USED_BY

  # callbacks

    before_validation :remove_blanks
    before_save :remove_blanks
    after_save :update_place_age_flags
    after_destroy :update_place_age_flags
    after_update :queue_send_mail

    def queue_send_mail
      # record is initially created with no data
      # so test if required fields have values
      # - if so, new
      # - else edit
      if self.description_was.nil? && self.description_changed?
        NotificationTrigger.add_admin_moderation(:admin_moderate_new_place_service, self.id)
      else
        NotificationTrigger.add_admin_moderation(:admin_moderate_edit_place_service, self.id)
      end
    end


    def remove_blanks
      geographic_area_municipalities.reject!(&:blank?)
      service_type.reject!(&:blank?)
      age_groups.reject!(&:blank?)
      diagnoses.reject!(&:blank?)
      service_activities.reject!(&:blank?)
      service_specialists.reject!(&:blank?)
    end

    # use the age_groups values to set the for_adults and for_children flags in the place object
    # - 1 or 2 = children
    # - 3 or 4 = adults
    # - has_age_restriction = false then both
    def update_place_age_flags
      self.place.update_age_flags
    end

  # validators

    validates :service_type, :description, :can_be_used_by, presence: true
    validates :is_restricited_geographic_area, :has_age_restriction, inclusion: { in: [true, false] }
    validates :need_finance, inclusion: { in: [true, false, nil] }
    validate :optional_required_fields


    # when some fields have a certain value, other fields become required
    # is_restricited_geographic_area = no -> geographic_area_municipalities
    # has_age_restriction = no ->  age_groups
    # can_be_used_by = diagnosis_without_status -> diagnoses
    def optional_required_fields
      if self.is_restricited_geographic_area == true && self.geographic_area_municipalities.empty?
        self.errors.add(:geographic_area_municipalities, I18n.t('admin.shared.is_required'))
      end

      if self.has_age_restriction == true && self.age_groups.empty?
        self.errors.add(:age_groups, I18n.t('admin.shared.is_required'))
      end

      if self.can_be_used_by == 'diagnosis_without_status' && self.diagnoses.empty?
        self.errors.add(:diagnoses, I18n.t('admin.shared.is_required'))
      end
    end

  # helpers
    def self.validation_order_list
      [:is_restricited_geographic_area, :geographic_area_municipalities,
        :service_type, :act_regulating_service, :act_link, :description,
        :has_age_restriction, :age_groups, :can_be_used_by, :diagnoses,
        :service_activities, :service_specialists, :need_finance, :get_involved_link, :published]
    end

  # scopes
    scope :only_deleted, -> { where.not(deleted: 0) }
    scope :only_published, -> { where(published: true) }
    scope :only_active, -> { where(deleted: 0) }
    scope :sorted, -> { order(service_id: :asc) }
    scope :sorted_date, -> { order(created_at: :desc) }

  # class methods
    def self.service_types_for_list
      SERVICE_TYPES.map{|k,v| [v, I18n.t("activerecord.attributes.place_service.service_types.#{k}")]}
    end

    def self.age_groups_for_list
      AGE_GROUPS.map{|k,v| [v, k]}
    end

    def self.can_be_used_by_for_list
      CAN_BE_USED_BY.map{|k,v| [k, I18n.t("activerecord.attributes.place_service.can_be_used_bies.#{k}")]}
    end

  # methods

    def service_icon
      self.service.root? ? self.service.icon : self.service.parent.icon
    end

    def root_service_name
      self.service.root? ? self.service.name : self.service.parent.name
    end

    def municipalities
      if is_restricited_geographic_area && geographic_area_municipalities.present?
        Municipality.with_translations(I18n.locale).sorted.where(id: geographic_area_municipalities)
      end
    end

    def is_service_type_municipal?
      service_type.include?(SERVICE_TYPES[:municipal])
    end

    def is_service_type_state?
      service_type.include?(SERVICE_TYPES[:state])
    end

    def is_service_type_private_org?
      service_type.include?(SERVICE_TYPES[:private_org])
    end

    def age_groups_formatted
      if has_age_restriction && age_groups.present?
        ages = []
        age_groups.sort.each do |age|
          ages << AGE_GROUPS.keys[AGE_GROUPS.values.index(age)].to_s
        end
        return ages
      end
    end

    def can_be_used_by_diagnosis_without_status?
      can_be_used_by == 'diagnosis_without_status'
    end
end
