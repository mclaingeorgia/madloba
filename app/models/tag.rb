class Tag < ActiveRecord::Base
  # belongs_to :places
  belongs_to :place
  belongs_to :user

  has_many :place_tags
  has_many :places, through: :place_tags, source: :place

  scope :accepted, -> { where(processed: 1) }
  scope :pended, -> { where(processed: 0) }
  scope :active, -> { where(processed: [0,1]) }
  scope :declined, -> { where(processed: 2) }


  def self.process(user_id, place_id, tags)
    tag_ids = []

    if tags.kind_of?(Array)
      tags.each{ |tag|
        t = Tag.find_by(name: tag)
        if !t.present?
          t = Tag.create(user_id: user_id, place_id: place_id, name: tag)
          NotificationTrigger.add_admin_moderation(:admin_moderate_tag, t.id)
        end
        tag_ids << t.id
      }
    end

    tag_ids
  end

  def self.remove_pended(tag_ids)
     Rails.logger.debug("--------------------------------------remove_pended------#{tag_ids}")
    Tag.pended.where(id: tag_ids).each{|tag|
     # Rails.logger.debug("--------------------------------------remove_pended inside------#{tag.inspect}#{tag.places.size}")
      tag.destroy if tag.places.size == 0
    }
  end

  def can_accept?
    [0,2].include?(self.processed)
  end
  def can_decline?
    [0,1].include?(self.processed)
  end
  def is_processed?
    [1,2].include?(self.processed)
  end
  def is_pending?
    [0].include?(self.processed)
  end
  def processed_human
    ['pending', 'accepted', 'declined'][self.processed]
  end

  # filters

  def self.autocomplete(q)
    Tag.where('lower(name) like ?', "%#{q.downcase}%").pluck(:name, :processed).map{|m| { id: m[0], text: m[0] + (m[1] == 2 ? I18n.t('activerecord.models.tag.declined') : ''), state: m[1], disabled: m[1] == 2 } } +
    (Tag.where('name = ?', q).present? ? [] : [ id: q, text: q, state: 0, disabled: false])
  end
end
