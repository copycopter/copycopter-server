FactoryGirl.define do
  sequence(:key) { |n| "key#{n}" }
  sequence(:name) { |n| "name#{n}" }

  factory :locale do
    key
    project
  end

  factory :blurb do
    project
  end

  factory :localization do
    blurb
    locale
  end

  factory :project do
    name
  end

  factory :version do
    localization

    factory :published_version do
      published true
    end
  end
end
