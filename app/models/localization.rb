class Localization < ActiveRecord::Base
  belongs_to :blurb
  belongs_to :locale
  belongs_to :published_version, :class_name => 'Version'
  has_many :versions

  validates_presence_of :blurb_id, :locale_id

  after_create :create_first_version

  def alternates
    blurb.localizations.joins(:locale).where(:locales => { :enabled => true }).
      order 'locales.key'
  end

  def as_json(options = nil)
    super :only => [:id, :draft_content], :methods => [:key]
  end

  def key
    blurb.key
  end

  def key_with_locale
    [locale.key, blurb.key].join '.'
  end

  def self.in_locale(locale)
    where :locale_id => locale.id
  end

  def latest_version
    versions.last
  end

  def self.latest_version
    # https://github.com/copycopter/copycopter-server/issues/64#issuecomment-5836709
    if ActiveRecord::Base.connection_config[:adapter].include? "mysql"
      <<-eosql
      SELECT DISTINCT localization_id, id, content
        FROM versions ORDER BY localization_id DESC, id DESC
      eosql
    else 
      <<-eosql
      SELECT DISTINCT ON (localization_id) localization_id, id, content
        FROM versions ORDER BY localization_id DESC, id DESC
      eosql
    end
  end

  def next_version_number
    versions.count + 1
  end

  def self.ordered
    joins(:blurb).order 'blurbs.key'
  end

  def self.publish
    # https://github.com/copycopter/copycopter-server/issues/64#issuecomment-5836709
    if ActiveRecord::Base.connection_config[:adapter].include? "mysql"
      ActiveRecord::Base.connection.execute <<-eosql
        UPDATE localizations
          INNER JOIN (
            #{latest_version}
          ) latest_version 
        ON localizations.id = latest_version.localization_id
          SET published_version_id = latest_version.id,
              published_content = latest_version.content,
              updated_at = '#{connection.quoted_date(Time.now)}'
              WHERE localizations.id IN (#{scoped.map(&:id).join(',')});
      eosql
    else
      ActiveRecord::Base.connection.execute <<-eosql
        UPDATE localizations
          SET published_version_id = latest_version.id,
          published_content = latest_version.content,
          updated_at = '#{connection.quoted_date(Time.now)}'
        FROM (
            #{latest_version}
          ) AS latest_version
        WHERE latest_version.localization_id = localizations.id
        AND localizations.id IN (#{scoped.map(&:id).join(',')});
      eosql
    end
  end

  def publish
    self.class.where(:id => self.id).publish
    reload
  end

  def project
    blurb.project
  end

  def revise(attributes = {})
    latest_version.revise attributes
  end

  private

  def create_first_version
    versions.build(:content => draft_content).tap do |version|
      version.number = 1
      version.save!
    end
  end
end
