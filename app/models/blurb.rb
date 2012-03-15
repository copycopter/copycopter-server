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
    blurbs = connection.select_rows(scope.to_sql)
    
    data = blurbs.inject({}) do |result, (blurb_key, locale_key, content)|
      key = [locale_key, blurb_key].join(".")
      result.update key => content
    end

    hierarchichal_data = blurbs.inject({}) do |result, (blurb_key, locale_key, content)|
      keys = []
      keys = blurb_key.split('.') if blurb_key
      result.deep_merge!({ locale_key => create_hierarchichal_hash_from_array(keys + [content]) })
    end

    { :data => data, :hierarchichal_data => hierarchichal_data }
  end

  def self.keys
    select('key').map { |blurb| blurb.key }
  end

  private
  def self.create_hierarchichal_hash_from_array(array_hierarchy, hash_hierarchy = {})
    return hash_hierarchy if array_hierarchy.empty?

    # The last 2 values in the array are the most drilled down part, so given:
    # [d,c,b,a,1]
    # The first Iteration you would get:
    # { "a" => 1 }
    # Second iteration:
    # { "b" => { "a" => 1 } }, etc..
    #
    if hash_hierarchy.empty?
      value = array_hierarchy.pop
      hash_hierarchy.merge!(array_hierarchy.pop => value)
    else
      hash_hierarchy = { array_hierarchy.pop => hash_hierarchy }
    end

    return create_hierarchichal_hash_from_array(array_hierarchy, hash_hierarchy)
  end

  def update_project_caches
    project.update_caches
  end
end
