Gem::Specification.new do |s|
  s.name        = 'ehpt'
  s.version     = '1.0.0'
  s.date        = '2019-10-23'
  s.summary     = "Employment Hero's Pivotal Tracker"
  s.description = 'A tool to create Pivotal Tracker story from CSV file'
  s.authors     = ['phamhoaivu911']
  s.email       = ''
  s.files       = ['lib/ehpt.rb']
  s.homepage    = 'https://github.com/phamhoaivu911/ehpt'
  s.license     = 'MIT'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'

  s.add_dependency 'tracker_api'
  s.add_dependency 'csv'
end
