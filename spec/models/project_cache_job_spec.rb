require 'spec_helper'

describe ProjectCacheJob do
  context "#perform" do
    it "updates the project's caches" do
      Project.stubs(:find => project)
      project.stubs(:update_caches)

      subject.perform

      Project.should have_received(:find).with(project.id)
      project.should have_received(:update_caches)
    end

    it "ignores a missing project" do
      Project.stubs(:find).raises(ActiveRecord::RecordNotFound)

      expect { subject.perform }.to_not raise_error
    end
  end

  let(:project) { Factory.stub(:project) }
  subject { ProjectCacheJob.new(project.id) }
end
