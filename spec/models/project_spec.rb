require 'spec_helper'

describe Project do
  it { should have_many(:blurbs) }
  it { should have_many(:locales).dependent(:delete_all) }
  it { should have_many(:localizations).through(:blurbs) }
  it { should belong_to(:draft_cache).dependent(:destroy) }
  it { should belong_to(:published_cache).dependent(:destroy) }

  it 'should require case-sensitive unique values for api_key' do
    project = Factory(:project)
    other_project = Factory(:project)
    project.api_key = other_project.api_key

    project.should_not be_valid
    project.errors[:api_key].should == ['has already been taken']
  end

  it 'should set the API key on create' do
    project = Factory.build(:project)
    project.api_key = nil

    project.save

    project.api_key.should_not be_nil
  end

  it 'publishes the latest version of each localization on deploy' do
    project = Factory(:project)
    other_project_localization = Factory(:localization, :draft_content => 'ignore me')
    project.create_defaults(
      'en.one' => 'publish me',
      'en.two' => 'me too'
    )

    project.localizations.each do |localization|
      localization.published_content.should be_empty
    end

    project.deploy!

    project.localizations.each do |localization|
      localization.reload.published_content.should == localization.draft_content
    end

    other_project_localization.reload.published_content.should be_empty
  end

  it 'returns draft hash' do
    project = Factory(:project)
    project.create_defaults('en.test.key' => 'value')

    project.reload.draft_json.should == Yajl::Encoder.encode('en.test.key' => 'value')
  end

  it 'returns published hash' do
    project = Factory(:project)
    project.create_defaults('en.test.key' => 'value')
    project.deploy!
    project.blurbs.first.localizations.first.revise(:content   => 'new value',
                                                    :published => false).save!

    project.reload.published_json.should == Yajl::Encoder.encode('en.test.key' => 'value')
  end

  it 'returns a different draft etag after updating draft content' do
    project = Factory(:project)
    project.create_defaults('en.test.one' => 'value')
    original_etag = project.reload.etag
    Timecop.travel 1.second.from_now

    project.blurbs.first.localizations.first.revise(
      :published => false, :content => 'new value'
    ).save!

    project.reload.etag.should_not == original_etag
  end

  it 'returns the same draft etag without updating draft content' do
    project = Factory(:project)
    project.create_defaults('en.test.one' => 'value')
    original_etag = project.reload.etag
    Timecop.travel(1.second.from_now)

    project.reload.etag.should == original_etag
  end

  it 'updates the etag when a blurb is deleted' do
    project = Factory(:project)
    project.create_defaults('en.test.one' => 'value')
    project.deploy!
    project.reload
    original_etag = project.etag
    Timecop.travel(1.second.from_now)

    project.blurbs.first.destroy
    project.reload

    project.etag.should_not == original_etag
  end

  it 'updates etag when deployed' do
    project = Factory(:project)
    project.create_defaults 'en.test.one' => 'value'
    project.deploy!
    project.create_defaults 'en.test.two' => 'value'
    project.reload
    original_etag = project.etag
    Timecop.travel 1.second.from_now

    project.deploy!

    project.reload.etag.should_not == original_etag
  end

  it 'generates cached json' do
    project = Factory(:project)
    project.create_defaults 'en.test.key' => 'value'
    project.deploy!
    project.blurbs.first.localizations.first.revise(
      :content => 'new value', :published => false
    ).save!
    TextCache.update_all "data = ''"

    Project.regenerate_caches

    project.reload
    project.draft_json.should == Yajl::Encoder.encode('en.test.key' => 'new value')
    project.published_json.should == Yajl::Encoder.encode('en.test.key' => 'value')
  end

  it 'starts with an English locale' do
    Factory(:project).locales.map(&:key).should == %w(en)
  end

  it 'uses a DefaultCreator to create defaults' do
    default_creator = stub('Default creator', :create => nil)
    DefaultCreator.stubs :new => default_creator

    project = Factory(:project)
    defaults = stub('Defaults')

    project.create_defaults defaults

    DefaultCreator.should have_received(:new).with(project, defaults)
    default_creator.should have_received(:create)
  end
end

describe Project, '#default_locale' do
  before do
    @project = Factory(:project)
    @project.locales.stubs :first_enabled => 'expected'
  end

  it 'returns the first enabled locale' do
    @project.default_locale.should == 'expected'
  end
end

describe Project, '#locale' do
  before do
    @project = Factory(:project)
  end

  context 'given an id' do
    before do
      @locale = Factory(:locale, :project => @project)
    end

    it 'returns the locale by id' do
      @project.locale(@locale.id).should == @locale
    end
  end

  context 'given no id' do
    before do
      @project.locales.stubs :first_enabled => 'expected'
    end

    it 'returns the first enabled locale' do
      @project.locale(nil).should == 'expected'
    end
  end
end

describe Project, '#destroy with blurb and localization data' do
  subject { FactoryGirl.create :project }
  let!(:blurbs) { FactoryGirl.create_list(:blurb, 5, :project => subject) }
  let!(:localizations) { blurbs.map {|blurb| FactoryGirl.create(:localization, :blurb => blurb) } }

  it 'deletes all associated data' do
    subject.destroy
    Blurb.where(:project_id => subject.id).count.should be_zero
    Localization.where(:blurb_id => blurbs.map(&:id)).count.should be_zero
  end
end
