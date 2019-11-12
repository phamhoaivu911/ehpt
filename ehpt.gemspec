Gem::Specification.new do |s|
  s.name        = 'ehpt'
  s.version     = '1.0.3'
  s.date        = '2019-10-23'
  s.summary     = "Employment Hero Pivotal Tracker"
  s.description = 'A command line tool to create Pivotal Tracker stories from CSV file'
  s.authors     = ['phamhoaivu911']
  s.email       = ''
  s.files       = [
    'lib/ehpt.rb',
    'lib/ehpt/base.rb',
    'lib/ehpt/create_stories.rb',
    'lib/ehpt/create_story.rb',
    'lib/ehpt/get_project.rb'
  ]
  s.homepage    = 'https://github.com/phamhoaivu911/ehpt'
  s.license     = 'MIT'
  s.executables << 'ehpt'

  s.add_development_dependency 'rake', '13.0.0'
  s.add_development_dependency 'rspec', '3.9.0'
  s.add_development_dependency 'byebug', '11.0.1'

  s.add_dependency 'tracker_api', '~> 1.10', '>= 1.10.0'
  s.add_dependency 'csv', '~> 3.1', '>= 3.1.2'
end
