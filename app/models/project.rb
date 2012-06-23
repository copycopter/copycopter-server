require 'extensions/string'

class Project < ActiveRecord::Base
  # Attributes
  attr_accessible :name, :password, :username

  # Associatons
  has_many :blurbs
  belongs_to :draft_cache, class_name: 'TextCache', dependent: :destroy
  has_many :locales, dependent: :delete_all
  has_many :localizations, through: :blurbs
  belongs_to :published_cache, class_name: 'TextCache', dependent: :destroy

  # Validations
  validates_presence_of :api_key, :name, :password, :username
  validates_uniqueness_of :api_key

  # Callbacks
  before_validation :generate_api_key, on: :create
  before_create :create_caches
  after_create :create_english_locale
  after_destroy :delete_localizations_and_blurbs

  def self.archived
    where archived: true
  end

  def self.active
    where archived: false
  end

  def active?
    !archived
  end

  def self.by_name
    order 'projects.name'
  end

  def create_defaults(hash)
    DefaultCreator.new(self, hash).create
  end

  def default_locale
    locales.first_enabled
  end

  def deploy!
    localizations.publish
    update_caches
  end

  def draft_json(options = { hierarchy: false })
    if options[:hierarchy]
      draft_cache.hierarchichal_data
    else
      draft_cache.data
    end
  end

  def etag
    [updated_at.to_i.to_s, updated_at.usec.to_s].join
  end

  def locale(locale_id = nil)
    if locale_id
      locales.find locale_id
    else
      default_locale
    end
  end

  def lock_key_for_creating_defaults
    "project-#{id}-create-defaults"
  end

  def published_json(options = { hierarchy: false })
    if options[:hierarchy]
      published_cache.hierarchichal_data
    else
      published_cache.data
    end
  end

  def self.regenerate_caches
    find_each do |project|
      project.update_caches
    end
  end

  def update_caches
    draft_cache.update_attributes!(generate_json(:draft_content))
    published_cache.update_attributes!(generate_json(:published_content))
    touch
  end

  private

  def create_caches
    self.draft_cache = TextCache.create!(:data => '{}')
    self.published_cache = TextCache.create!(:data => '{}')
  end

  def create_english_locale
    locales.create! key: 'en'
  end

  def delete_localizations_and_blurbs
    transaction do
      blurb_ids = Blurb.select('id').where(project_id: self.id).map(&:id)
      Localization.where(blurb_id: blurb_ids).delete_all
      Blurb.where(project_id: self.id).delete_all
    end
  end

  def generate_api_key
    self.api_key = SecureRandom.hex(24)
  end

  def generate_json(content)
    blurbs_hash = blurbs.to_hash(content)
    blurbs_hash[:data] = Yajl::Encoder.encode blurbs_hash[:data]
    blurbs_hash[:hierarchichal_data] = Yajl::Encoder.encode blurbs_hash[:hierarchichal_data]
    blurbs_hash
  end
end
