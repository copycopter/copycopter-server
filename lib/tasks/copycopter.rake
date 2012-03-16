namespace :copycopter do
  task :regenerate_project_caches => :environment do
    Project.regenerate_caches
  end

  task :project => :environment do
    project = Project.new(:name => ENV['NAME'], :password => ENV['PASSWORD'], :username => ENV['USERNAME'])

    if project.save
      puts "Project #{project.name} created!"
    else
      puts "There were errors creating the project: #{project.errors.full_messages}"
    end
  end
end
