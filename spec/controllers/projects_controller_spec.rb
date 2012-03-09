require 'spec_helper'

describe ProjectsController, 'show' do
  before do
    @project = Factory(:project)
    @project.create_defaults 'en.test' => 'value'
  end

  it 'returns a 304 response for a fresh etag' do
    request.stubs :fresh? => true
    get :show, :id => @project
    should respond_with(304)
  end

  it 'returns a 200 response for a stale etag' do
    request.stubs :fresh? => false
    response.stubs :etag=
    get :show, :id => @project
    should respond_with(200)
    response.should have_received(:etag=).with(@project.reload.etag)
  end
end
