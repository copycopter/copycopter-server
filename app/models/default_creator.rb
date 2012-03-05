class DefaultCreator
  def initialize(project, hash)
    @project  = project
    @hash = hash
    @missing_localizations = {}
    parse_defaults
  end

  def create
    find_blurbs
    find_locales
    find_localized_defaults

    project.transaction do
      add_new_locales

      defaults.each do |locale_key, locale_defaults|
        locale_defaults.each do |blurb_key, content|
          create_default_for locale_key, blurb_key, content
        end
      end

      create_missing_localizations

      project.schedule_cache_update
    end
  end

  private

  attr_reader :project, :defaults

  def add_new_locales
    locale_keys_with_new_defaults = @defaults.keys.uniq

    new_locale_keys = locale_keys_with_new_defaults.reject do |locale_key|
      @locales.key? locale_key
    end

    new_locale_keys.each do |locale_key|
      new_locale = project.locales.create!(:key => locale_key)
      @locales[locale_key] = new_locale

      @blurbs.each do |blurb|
        @missing_localizations[blurb.key] ||= []
        @missing_localizations[blurb.key] << new_locale
      end
    end
  end

  def connection
    ActiveRecord::Base.connection
  end

  def create_default_for(locale_key, blurb_key, content)
    locale = @locales[locale_key]
    blurb = find_or_create_blurb(blurb_key)
    declare_blurb blurb
    localize_blurb blurb, locale, content
  end

  def create_localization(blurb, locale, content)
    blurb.localizations.create! :locale => locale, :draft_content => content
    content
  end

  def create_missing_localizations
    @missing_localizations.each do |blurb_key, locales|
      blurb = @blurbs[blurb_key]

      @locales.each do |locale|
        localize_blurb blurb, locale, default_for(blurb)
      end
    end
  end

  def declare_blurb(blurb)
    @missing_localizations[blurb.key] ||= @locales.values
  end

  def default_for(blurb)
    @localized_defaults[blurb.id][default_locale.id] || ''
  end

  def default_locale
    @default_locale ||= project.default_locale
  end

  def find_blurbs
    @blurbs = KeyedRelation.new(project.blurbs)
  end

  def find_locales
    @locales = KeyedRelation.new(project.locales)
  end

  def find_localized_defaults
    scope = Localization.
      joins(:blurb).
      where(:blurbs => { :project_id => project.id }).
      select('localizations.locale_id, localizations.blurb_id, localizations.draft_content')
      @localized_defaults = connection.select_rows(scope.to_sql).inject({}) do |result, (locale_id, blurb_id, content)|
      result.update blurb_id.to_i => (result[blurb_id.to_i] || {}).update(locale_id.to_i => content)
    end
  end

  def find_or_create_blurb(key)
    @blurbs[key] ||= project.blurbs.create!(:key => key)
  end

  def localize_blurb(blurb, locale, content)
    @localized_defaults[blurb.id] ||= {}
    @localized_defaults[blurb.id][locale.id] ||= create_localization(blurb, locale, content)
    @missing_localizations[blurb.key].delete(locale)
  end

  def parse_defaults
    @defaults = @hash.inject({}) do |result, (key, default)|
      if key.present?
        locale_key, blurb_key = *key.split_key_with_locale
        result[locale_key] ||= {}
        result[locale_key][blurb_key] = default
      end

      result
    end
  end
end
