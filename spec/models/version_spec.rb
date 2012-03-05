require 'spec_helper'

describe Version do
  it { should belong_to(:localization) }
  it { should validate_presence_of(:localization_id) }
  it { should_not allow_mass_assignment_of(:localization_id) }
  it { should allow_mass_assignment_of(:content) }
  it { should allow_mass_assignment_of(:published) }

  it 'uses a preassigned number' do
    Factory(:version, :number => 3).reload.number.should == 3
  end
end

describe Version, 'valid?' do
  subject { Factory.build :version }

  it 'delegates project to localization' do
    subject.project.should == subject.localization.project
  end
end

describe Version, 'revised without new content' do
  let(:previous_version) { Factory :version, :content => 'hello' }
  subject { previous_version.revise }

  it 'has the same localization' do
    subject.localization.should == previous_version.localization
  end

  it 'uses the previous content' do
    subject.content.should == previous_version.content
  end
end

describe Version, 'revised with new content' do
  let(:previous_version) { Factory :version }
  let(:revised_content) { 'new content' }
  let(:localization) { subject.localization }
  subject { previous_version.revise :content => revised_content }

  it 'has the same localization' do
    subject.localization.should == previous_version.localization
  end

  it 'uses the revised content' do
    subject.content.should == revised_content
  end

  it 'updates the localization when saved' do
    subject.save!
    localization.reload.draft_content.should == revised_content
  end

  it 'publishes' do
    subject.published = true
    subject.save!
    localization.reload.published_content.should == revised_content
    localization.published_version.should == subject
    subject.should be_published
  end

  it 'creates a draft' do
    subject.published = false
    subject.save!
    localization.reload.published_content.should_not == revised_content
    localization.published_version.should_not == subject
    subject.should_not be_published
  end
end

describe Version, 'published' do
  subject { Factory(:published_version) }

  it 'generates a published version when revised' do
    subject.revise.should be_published
  end
end

