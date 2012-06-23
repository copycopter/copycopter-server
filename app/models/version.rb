class Version < ActiveRecord::Base
  # Attributes
  attr_accessible :content, :published

  # Associations
  belongs_to :localization

  # Validations
  validates_presence_of :localization_id

  # Callbacks
  before_validation :set_number, on: :create
  after_create :update_localization
  after_create :update_project_caches, :unless => :first_version?

  def revise(attributes = {})
    localization.
      versions.
      build self.attributes.merge('published' => published).merge(attributes)
  end

  def project
    localization.project
  end

  def published=(published)
    @publish_after_saving =
      ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(published)
  end

  def published
    if new_record?
      publish_after_saving?
    else
      localization.published_version_id == id
    end
  end

  def published?
    published
  end

  private

  def publish_after_saving?
    @publish_after_saving
  end

  def set_number
    if !number && localization
      self.number = localization.next_version_number
    end
  end

  def update_localization
    unless first_version?
      localization.update_attributes! draft_content: content
    end

    if publish_after_saving?
      localization.publish
    end
  end

  def update_project_caches
    project.update_caches
  end

  def first_version?
    number == 1
  end
end
