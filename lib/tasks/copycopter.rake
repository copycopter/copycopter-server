namespace :copycopter do
  task :regenerate_project_caches => :environment do
    Project.regenerate_caches
  end
end
