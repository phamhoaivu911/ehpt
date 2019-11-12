require 'pp'
require 'csv'
require 'ehpt/get_project'
require 'ehpt/create_stories'

module Ehpt
  def self.call(csv_file, token, project_id)
    project_getter = Ehpt::GetProject.new(token, project_id)
    project_getter.call

    if project_getter.error?
      puts "===== Errors ====="
      pp project_getter.errors
      return
    end

    puts "Found project: #{project_getter.data.name}"
    project = project_getter.data

    stories_creator = Ehpt::CreateStories.new(csv_file, project)
    stories_creator.call

    puts "Done"

    if stories_creator.error?
      puts "===== Errors ====="
      pp stories_creator.errors
    end
  end
end
