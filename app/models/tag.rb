class Tag < ActiveRecord::Base
  translates :name
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name ]

  belongs_to :places


  def self.process(user_id, place_id, tags)
    tag_ids = []

    if tags.kind_of?(Array)
      tags.each{ |tag|
        t = Tag.find_by(name: tag)
        if !t.present?
          t = Tag.create(user_id: user_id, place_id: place_id, name: tag)
        end
        tag_ids << t.id
      }
    end

    tag_ids
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
end
