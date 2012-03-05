require 'spec_helper'

describe HomesController, 'show' do
  it 'renders the home page' do
    get :show
    response.should be_success
    should render_template(:show)
    should render_with_layout(:homes)
  end
end
