require 'spec_helper'

describe "/shared/_flashes" do
  let(:display) { %w(success error notice failure alert).map(&:to_sym) }
  let(:ignore) { %w(info some_id).map(&:to_sym) }
  let(:keys) { display + ignore }

  before do
    keys.each { |key| flash[key] = "value for #{key}" }
    render :partial => 'shared/flashes'
  end

  it 'renders each displayed key' do
    display.each do |key|
      rendered.should include(flash[key])
    end
  end

  it 'does not render any ignored keys' do
    ignore.each do |key|
      rendered.should_not include(flash[key])
    end
  end
end
