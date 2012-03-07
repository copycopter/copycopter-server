require 'extensions/string'

class Blurb < ActiveRecord::Base
  include HTMLDiff

  # Associations
  belongs_to :project
  has_many :localizations, :dependent => :destroy

  # Validations
  validates_presence_of :project_id

  # Callbacks
  after_destroy :update_project_caches

  def self.ordered
    order 'blurbs.key ASC'
  end

  def self.to_hash(attribute)
    scope = joins(:localizations => :locale).
      select("blurbs.key AS blurb_key, locales.key AS locale_key, #{attribute} AS content")
    connection.select_rows(scope.to_sql).inject({}) do |result, (blurb_key, locale_key, content)|
      key = [locale_key, blurb_key].join(".")
      result.update key => content
    end
  end

  def self.keys
    select('key').map { |blurb| blurb.key }
  end

  private

  def update_project_caches
    project.schedule_cache_update
  end
end
