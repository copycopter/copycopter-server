require 'spec_helper'

describe String, "extensions" do
  it "finds a key and locale" do
    key_with_locale = "en.test.key"
    locale, key = *key_with_locale.split_key_with_locale
    locale.should == 'en'
    key.should == 'test.key'
  end
end
