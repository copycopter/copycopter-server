class CreateSchema < ActiveRecord::Migration
  def up
    create_table 'blurbs', :force => true do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string 'key'
      t.integer 'project_id'
    end

    add_index 'blurbs', ['project_id', 'key'],
      :name => 'index_blurbs_on_project_id_and_key', :unique => true

    create_table 'delayed_jobs', :force => true do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer 'attempts', :default => 0
      t.datetime 'failed_at'
      t.text 'handler'
      t.text 'last_error'
      t.datetime 'locked_at'
      t.string 'locked_by'
      t.integer 'priority', :default => 0
      t.datetime 'run_at'
    end

    add_index 'delayed_jobs', ['priority', 'run_at'],
      :name => 'delayed_jobs_priority'

    create_table 'locales', :force => true do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.boolean 'enabled', :default => true, :null => false
      t.string 'key'
      t.integer 'project_id'
    end

    add_index 'locales', ['project_id', 'key'],
      :name => 'index_locales_on_project_id_and_key', :unique => true

    create_table 'localizations', :force => true do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer 'blurb_id'
      t.text 'draft_content', :default => '', :null => false
      t.integer 'locale_id'
      t.text 'published_content', :default => '', :null => false
      t.integer 'published_version_id'
    end

    add_index 'localizations', ['blurb_id'],
      :name => 'index_localizations_on_blurb_id'

    create_table 'projects', :force => true do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string 'api_key'
      t.boolean 'archived', :default => false, :null => false
      t.integer 'draft_cache_id'
      t.string 'name'
      t.integer 'published_cache_id'
    end

    add_index 'projects', ['archived'], :name => 'index_projects_on_archived'

    create_table 'text_caches', :force => true do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.text 'data'
    end

    create_table 'versions', :force => true do |t|
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.text 'content', :default => '', :null => false
      t.integer 'localization_id'
      t.integer 'number', :null => false
    end

    add_index 'versions', ['localization_id'],
      :name => 'index_versions_on_localization_id'
  end

  def down
    drop_table 'blurbs'
    drop_table 'delayed_jobs'
    drop_table 'locales'
    drop_table 'localizations'
    drop_table 'projects'
    drop_table 'text_caches'
    drop_table 'versions'
  end
end
