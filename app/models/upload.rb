class Upload < ActiveRecord::Base
  belongs_to :place
  belongs_to :user
  belongs_to :asset

  def get_state
    klass = 'pending'
    # text = t('shared.pending')

    if self.processed == 1
      klass = 'approved'
      # text = t('shared.approved')
    elsif self.processed == 2
      klass = 'declined'
      # text = t('shared.declined')
    end
    klass
  end
end

