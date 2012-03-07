require 'spec_helper'

describe DeployJob, 'perform' do
  before do
    @project = Factory(:project)
    @project.stubs :deploy! => true
    job = DeployJob.new(@project)
    @project.should_not have_received(:deploy!)
    job.perform
  end

  it 'deploys its project' do
    @project.should have_received(:deploy!)
  end
end
