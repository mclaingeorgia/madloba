class Ad < ActiveRecord::Base
  has_many :post_locations
  has_many :locations, through: :post_locations
  has_many :post_items
  has_many :items, through: :post_items
  belongs_to :user
  has_many :post_users
  has_many :favoriting_users, through: :post_users, source: :user
  has_and_belongs_to_many :categories

  include ApplicationHelper
  after_initialize :default_values

  # Ad image
  mount_uploader :image, ImageUploader

  process_in_background :image if :image_storage == IMAGE_AMAZON_S3
  store_in_background :avatar if :image_storage == IMAGE_ON_SERVER

  accepts_nested_attributes_for :post_locations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :post_items, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :items
  accepts_nested_attributes_for :locations

  validates_presence_of :title, :description

  validates :giving, inclusion: [true, false]
  validates :username_used, inclusion: [true, false]
  validates :is_published, inclusion: [true, false]
  validate :has_items
  validate :has_locations
  validate :must_have_one_category
  validates_size_of :image, maximum: 5.megabytes

  # Fields to be translated
  translates :title, :description
  globalize_accessors :locales => [:en, :ka], :attributes => [:title]
  globalize_accessors :locales => [:en, :ka], :attributes => [:description]

  apply_simple_captcha

  def self.image_storage
    Rails.cache.fetch(CACHE_IMAGE_STORAGE) {Setting.find_or_create_by(key: 'image_storage').value}
  end

  # This method returns the right query to display relevant markers, on the home page.
  def self.search(cat_nav_state, searched_item, selected_item_ids, user_action, post_id)

    if post_id.present?
      # Search by post ids when adding posts on home page dynamically, when other user just created an post (websocket)
      posts = Post.find(post_id)
      posts = [posts.marker_info]
    else
      posts = Post.select(:marker_info).where("expire_date >= ? and (marker_info->>'post_id') is not null", Date.today)

      if cat_nav_state || searched_item
        if cat_nav_state
          puts cat_nav_state
          if searched_item
            # We search for posts in relation to the searched item and the current category navigation state.
            posts = posts.joins([:items, :categories]).where(categories: {id: cat_nav_state}, items: {id: selected_item_ids})
          else
            # We search for posts in relation to our current category navigation state.
            posts = posts.joins(:categories).where(categories: {id: cat_nav_state})
          end
        elsif searched_item
          posts = posts.joins(:items).where(items: {id: selected_item_ids})
        end
      end

      if user_action
        # If the user is searching for items, we need to show the posted posts, which people give stuff away.
        posts = posts.where("posts.giving = ?", user_action == 'searching')
      end

      posts = posts.pluck(:marker_info).uniq
    end

    posts
  end



  # method used to save the posts#new form. A captcha is required when the user is anonymous.
  # In that case the save method is different than the classic one.
  def save_with_or_without_captcha(current_user)
    if current_user
      self.save
    else
      self.username_used = false
      self.save_with_captcha
    end
  end

  def has_items
    errors.add(:base, I18n.t('post.error_post_must_have_item')) if (self.post_items.blank? || self.post_items.empty?)
  end

  def has_locations
    errors.add(:base, I18n.t('post.error_post_must_have_location')) if (self.post_locations.blank? || self.post_locations.empty?)
  end

  def has_anon_name_and_email
    errors.add(:base, I18n.t('post.provide_anon_name')) if (self.user_id.nil? && self.anon_name.blank?)
    errors.add(:base, I18n.t('post.provide_anon_email')) if (self.user_id.nil? && self.anon_email.blank?)
  end

  def must_have_one_category
    errors.add(:base, I18n.t('post.error_post_must_have_category')) if (self.categories.blank? || self.categories.empty?)
  end

  def no_user_at_all
    self.anon_email == nil && self.user == nil
  end

  def action
    giving? ? I18n.t('admin.post.giving_away') : I18n.t('admin.post.accepting')
  end

  def action_item
    act = giving? ? I18n.t('admin.post.giving_away') : I18n.t('admin.post.accepting')
    self.items.each do |item|

    end

    "#{act} #{self.items.map(&:name).join(', ')}"
  end

  # The publisher of an post might not want to have their full name publicly displayed.
  # This method defines whether to show the username or the full name (whether it is anonymous or registered user)
  def username_to_display
    if self.is_anonymous
      self.anon_name
    elsif self.username_used?
      self.user.username
    else
      "#{self.user.first_name} #{self.user.last_name}"
    end
  end

  # If we deal with an anonymous post publisher, we get the email from the post itself (no user model created)
  # Otherwise we get the email from the user model linked to the post.
  def email_to_display
    if self.no_user_at_all
      I18n.t('post.no_user_tied_yet')
    elsif self.is_anonymous
      self.anon_email
    else
      self.user.email
    end
  end

  def has_expired
    self.expire_date < Date.today
  end

  # Define whether or not this post has been created by a signed-in or an anonymous user.
  def is_anonymous
    (self.user_id == nil || self.user_id == 0) && self.anon_name != nil
  end

  def thumb_image_url
    self.image_url(:thumb)
  end

  def is_a_favorite_of(user)
    result = false
    if user && user.favorite_posts
      favorite_posts = user.favorite_posts.pluck(:id)
      result = favorite_posts.include?(self.id)
    end
    return result
  end

  def recreate_delayed_versions!
    self.image.is_processing_delayed = true
    self.image.recreate_versions!
  end

  # To be used in the map popup, on posts#show page.
  def item_list
    result = []
    self.post_items.each do |post_item|
      result << post_item.item.capitalized_name
    end
    return result.join(', ')
  end


  def serialize!
    locations = []
    info = {post_id: self.id}
    self.locations.each do |location|
      locations << {location_id: location.id, lat: location.latitude, lng: location.longitude}
    end
    info[:locations] = locations
    markers = []
    self.items.each do |i|
      cat = i.category
      marker = {icon: cat.icon, color: cat.marker_color, item_id: i.id, category_id: cat.id}
      markers << marker
    end
    info[:markers] = markers
    self.marker_info = info
    self.save
  end

  private

  # Setting default values after initialization, on posts#new
  def default_values
    if self.new_record?
      self.username_used = false
      self.is_published = false
      self.giving = true

      # we define the date when the post won't be published any longer (see maximum number of days, in Settings table)
      if max_number_days_publish == '0'
        # No limit set for post expiration. Let's use 2100-01-01 as a default date value
        self.expire_date = Date.new(2100,1,1)
      else
        d = Date.today
        self.expire_date = d + max_number_days_publish.to_i
      end
    end
  end

end
