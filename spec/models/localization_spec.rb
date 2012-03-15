require 'spec_helper'

describe Localization do
  it { should belong_to(:blurb) }
  it { should belong_to(:locale) }
  it { should belong_to(:published_version) }
  it { should have_many(:versions) }

  it { should validate_presence_of(:blurb_id) }
  it { should validate_presence_of(:locale_id) }

  it 'should have a collection of versions' do
    (Factory(:localization).respond_to?(:versions)).should be
    Factory(:localization).versions.first.should_not be_nil
  end

  describe 'a localization with two revisions' do
    before do
      @localization = Factory(:localization, :draft_content => 'default')
      @second = @localization.revise(:content => 'We <i>sell</i> delicious muffings!')
      @second.save!
      @third = @localization.
        revise(:content => 'We are the <b>world</b> leading supplier of premier muffins.')
      @third.save!
      @localization.reload
    end

    it 'should give the latest version when asked' do
      @localization.latest_version.content.
        should == 'We are the <b>world</b> leading supplier of premier muffins.'
    end

    it 'calculates the next version number' do
      @localization.next_version_number.should == 4
    end
  end

  it 'copies draft content when published' do
    new_content = 'publish me'
    localization = Factory(:localization)
    version = Factory(:version, :localization => localization, :content => new_content)

    localization.publish

    localization.published_content.should == new_content
    localization.published_version.should == version
  end

  it 'creates the first version without counting versions' do
    Version.stubs(:count => 0)
    localization = Factory.build(:localization)

    localization.save!

    localization.versions.last.number.should == 1
    Version.should have_received(:count).never
  end

  it 'returns a key with locale' do
    blurb = Factory.build(:blurb, :key => 'test.key')
    locale = Factory.build(:locale, :key => 'es')
    localization = Factory.build(:localization, :blurb => blurb, :locale => locale)
    localization.key_with_locale.should == 'es.test.key'
  end

  it 'returns a key without locale' do
    blurb = Factory.build(:blurb, :key => 'test.key')
    locale = Factory.build(:locale, :key => 'es')
    localization = Factory.build(:localization, :blurb => blurb, :locale => locale)
    localization.key.should == 'test.key'
  end

  it 'returns project of blurb' do
    localization = Factory.build(:localization)
    localization.project.should == localization.blurb.project
  end

  it 'orders by key' do
    project = Factory(:project)
    project.create_defaults(
      'en.def' => 'one',
      'en.abc' => 'two',
      'en.ghi' => 'three'
    )

    Localization.ordered.map(&:key).should == %w(abc def ghi)
  end

  context '#as_json' do
    subject { Factory(:localization) }
    let(:json) { subject.as_json.stringify_keys }

    %w(id key draft_content).each do |attribute|
      it 'includes #{attribute}' do
        json[attribute].should == subject.send(attribute)
      end
    end
  end

  context '#in_locale' do
    let!(:project) { Factory(:project) }
    let!(:locale) { Factory(:locale, :project => project) }
    let!(:other_locale) { Factory(:locale, :project => project) }

    let!(:localizations) do
      [Factory(:localization, :locale => locale),
       Factory(:localization, :locale => locale)]
    end

    let!(:other_localization) { Factory(:localization, :locale => other_locale) }
    let!(:result) { Localization.in_locale(locale).to_a }

    it 'returns only localizations for the given locale' do
      result.should =~ localizations
    end
  end

  context '#alternates' do
    let(:project) { Factory(:project) }
    let(:enabled_locales) { project.locales.where(:key => %w(en es)) }
    let(:disabled_locale) { project.locales.where(:key => 'de').first }

    before do
      project.create_defaults('en.test' => 'value',
        'es.test' => 'value',
        'de.test' => 'value')

      enabled_locales.each do |enabled_locale|
        enabled_locale.update_attributes!(:enabled => true)
      end

      disabled_locale.update_attributes!(:enabled => false)
    end

    subject { project.reload.localizations.first }

    let!(:result) { subject.alternates }
    let(:result_keys) { result.map { |localization| localization.locale.key } }

    it 'returns enabled locales for that blurb' do
      result_keys.should =~ enabled_locales.map(&:key)
    end

    it 'sorts by key' do
      result_keys.sort.should == result_keys
    end
  end
end

describe Localization, '.publish' do
  let(:old_content)      { 'old content' }
  let(:new_content)      { 'new content' }
  let(:more_new_content) { 'more new content' }

  let!(:localization_to_be_published)        { FactoryGirl.create(:localization) }
  let!(:second_localization_to_be_published) { FactoryGirl.create(:localization) }
  let!(:localization_not_to_be_published)    { FactoryGirl.create(:localization) }

  let!(:old_version_for_localization_to_be_published) { FactoryGirl.create(:version, :localization => localization_to_be_published, :content => old_content) }
  let!(:new_version_for_localization_to_be_published) { FactoryGirl.create(:version, :localization => localization_to_be_published, :content => new_content) }

  let!(:new_version_for_second_localization_to_be_published) { FactoryGirl.create(:version, :localization => second_localization_to_be_published, :content => more_new_content) }

  let!(:version_for_localization_not_to_be_published) { FactoryGirl.create(:version, :localization => localization_not_to_be_published, :content => new_content) }

  before { Timecop.freeze Time.now }
  after  { Timecop.return }

  def publish_data
    Localization.where(:id => [localization_to_be_published, second_localization_to_be_published]).publish
    localization_to_be_published.reload
    second_localization_to_be_published.reload
    localization_not_to_be_published.reload
  end

  it 'publishes the newest version of the content' do
    publish_data

    localization_to_be_published.published_version.should == new_version_for_localization_to_be_published
    localization_to_be_published.published_content.should == new_content
    localization_to_be_published.updated_at.to_i.should == Time.now.to_i
  end

  it 'publishes data for multiple localizations' do
    publish_data

    second_localization_to_be_published.published_version.should == new_version_for_second_localization_to_be_published
    second_localization_to_be_published.published_content.should == more_new_content
    second_localization_to_be_published.updated_at.to_i.should == Time.now.to_i
  end

  it 'does not publish localizations not selected to be published' do
    publish_data

    localization_not_to_be_published.published_version.should be_nil
    localization_not_to_be_published.published_content.should == ''
    localization_not_to_be_published.updated_at.should_not == Time.now
  end
end
