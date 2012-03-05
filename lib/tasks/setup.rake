task :setup => ['db:drop:all', 'db:create:all', 'db:migrate', :environment] do
  require 'factory_girl_rails'

  project = Factory(:project)
  blurb = Factory(:blurb, :project => project)
  Factory :localization, :blurb => blurb
end
