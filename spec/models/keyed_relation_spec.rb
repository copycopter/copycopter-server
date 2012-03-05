require 'spec_helper'

describe KeyedRelation do
  it "finds a known key" do
    record = create_keyed_record("test")
    keyed_relation["test"].should == record
  end

  it "returns nil for an unknown key" do
    create_keyed_record("test")
    keyed_relation["unknown"].should be_nil
  end

  it "returns an explicitly set value" do
    keyed_relation["test"] = "expected"
    keyed_relation["test"].should == "expected"
  end

  it "iterates records" do
    one = create_keyed_record("key.one")
    keyed_relation["key.two"] = "two"
    result = []
    keyed_relation.each { |record| result << record }
    result.should =~ [one, "two"]
  end

  it "has a known key" do
    one = create_keyed_record("key.one")
    keyed_relation["key.two"] = "two"
    keyed_relation.key?("key.one").should be_true
    keyed_relation.key?("key.two").should be_true
  end

  it "doesn't have an unknown key" do
    keyed_relation.key?("unknown").should be_false
  end

  it "returns records" do
    one = create_keyed_record("key.one")
    keyed_relation["key.two"] = "two"
    keyed_relation.values.should =~ [one, "two"]
  end

  def create_keyed_record(key)
    Factory(:blurb, :key => key)
  end

  let(:keyed_relation) { KeyedRelation.new(Blurb.all) }
end
