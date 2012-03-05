require 'spec_helper'

describe Locale do
  it { should belong_to(:project) }
  it { should have_many(:localizations).dependent(:destroy) }

  it { should validate_presence_of(:key) }
  it { should validate_presence_of(:project_id) }

  context 'self.enabled_in_order' do
    let!(:enabled_locales) { [Factory(:locale, :key => 'one'),
                              Factory(:locale, :key => 'two')] }
    let!(:disabled_locale) { Factory :locale, :key => 'disabled' }

    before do
      enabled_locales.each do |enabled_locale|
        enabled_locale.update_attributes! :enabled => true
      end

      disabled_locale.update_attributes! :enabled => false
    end

    let!(:result) { Locale.enabled_in_order.map(&:key) }

    it 'returns enabled locales' do
      enabled_locales.each do |enabled_locale|
        result.should include(enabled_locale.key)
      end
    end

    it 'sorts by key' do
      result.should == result.sort
    end

    it 'does not return disabled locales' do
      result.should_not include(disabled_locale)
    end
  end

  context 'self.first_enabled' do
    it 'returns the first enabled locale' do
      Factory :locale, :key => 'de', :created_at => 1.hour.ago
      Factory :locale, :key => 'fr', :created_at => 1.day.ago
      Factory :locale, :key => 'es', :created_at => 2.days.ago,
        :enabled => false
      Locale.first_enabled.key.should == 'fr'
    end
  end

  context 'valid?' do
    context 'with existing locale' do
      before do
        Factory :locale
      end

      it { should validate_uniqueness_of(:key).scoped_to(:project_id) }
    end
  end
end
