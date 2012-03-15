# encoding: utf-8

require 'spec_helper'

describe Blurb do
  it { should belong_to(:project) }
  it { should have_many(:localizations).dependent(:destroy) }

  it { should validate_presence_of(:project_id) }

  it 'orders by key' do
    blurb_z = Factory(:blurb, :key => 'zzz')
    blurb_a = Factory(:blurb, :key => 'aaa')
    expected = [blurb_a, blurb_z]

    Blurb.ordered.should == expected
  end

  it 'finds keys' do
    Factory :blurb, :key => 'test.one'
    Factory :blurb, :key => 'test.two'

    Blurb.keys.should =~ %w(test.one test.two)
  end
end

describe Blurb, 'given draft and published content for several blurbs and locales' do
  before do
    project = Factory(:project)
    en = project.locales.first
    fr = Factory(:locale, :key => 'fr', :project => project)
    one = Factory(:blurb, :key => 'test.one', :project => project)
    two = Factory(:blurb, :key => 'test.two', :project => project)

    Factory :localization, :blurb              => one,
                           :locale            => en,
                           :draft_content     => 'draft one',
                           :published_content => 'published one'
    Factory :localization, :blurb             => two,
                           :locale            => en,
                           :draft_content     => 'draft two',
                           :published_content => 'published two'
    Factory :localization, :blurb             => two,
                           :locale            => fr,
                           :draft_content     => 'ébauche',
                           :published_content => 'publié'
  end

  it 'returns draft hash' do
    Blurb.to_hash(:draft_content).should include(:data => {
      'en.test.one' => 'draft one',
      'en.test.two' => 'draft two',
      'fr.test.two' => 'ébauche'
    })
  end

  it 'returns published hash' do
    Blurb.to_hash(:published_content).should include(:data => {
      'en.test.one' => 'published one', 
      'en.test.two' => 'published two',
      'fr.test.two' => 'publié'
    })
  end

  it 'returns a draft hash maintaining hierarchy' do
    Blurb.to_hash(:draft_content).should include(:hierarchichal_data => {
      'en' => {
        'test' => {
          'one' => 'draft one',
          'two' => 'draft two'
        }
      },
      'fr' => {
        'test' => {
          'two' => 'ébauche'
        }
      }
    })
  end

  it 'returns a published hash maintaining hierarchy' do
    Blurb.to_hash(:published_content).should include(:hierarchichal_data => {
      'en' => {
        'test' => {
          'one' => 'published one',
          'two' => 'published two'
        }
      },
      'fr' => {
        'test' => {
          'two' => 'publié'
        }
      }
    })

  end
end
