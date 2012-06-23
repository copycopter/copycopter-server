namespace :copycopter do
  task :regenerate_project_caches => :environment do
    Project.regenerate_caches
  end

  desc 'Add a project to Copycopter'
  task :project => :environment do
    project = Project.new(:name => ENV['NAME'], :password => ENV['PASSWORD'], :username => ENV['USERNAME'])

    if project.save
      puts "Project #{project.name} created!"
    else
      puts "There were errors creating the project: #{project.errors.full_messages}"
    end
  end

  desc 'Remove the project from Copycopter'
  task :remove_project => :environment do
    project = Project.where(:name => ENV['NAME']).first

    if project.destroy
      puts "Project #{project.name} removed!"
    else
      puts "There were errors removing the project: #{project.errors.full_messages}"
    end
  end
end
