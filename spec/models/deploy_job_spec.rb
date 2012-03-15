require 'spec_helper'

describe DeployJob, 'perform' do
  before do
    @project = Factory(:project)
    @project.stubs :deploy! => true
    job = DeployJob.new(@project)
    @project.should have_received(:deploy!).never
    job.perform
  end

  it 'deploys its project' do
    @project.should have_received(:deploy!)
  end
end
