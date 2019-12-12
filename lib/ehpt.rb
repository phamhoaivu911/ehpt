require 'tracker_api'
require 'pp'
require 'csv'
require 'ehpt/base'
require 'ehpt/create_stories'
require 'ehpt/create_story'
require 'ehpt/create_story_attributes'
require 'ehpt/get_project'
require 'ehpt/get_user_id_from_initial'

module Ehpt
  def self.call(csv_file, token, project_id)
    project_getter = Ehpt::GetProject.new(token, project_id)
    project_getter.call

    if project_getter.error?
      puts "===== Errors ====="
      pp project_getter.errors
      return
    end

    set_project(project_getter.data)
    puts "Found project: #{project_getter.data.name}"

    stories_creator = Ehpt::CreateStories.new(csv_file)
    stories_creator.call

    puts "Done"

    if stories_creator.error?
      puts "===== Errors ====="
      pp stories_creator.errors
    end

    if stories_creator.warning?
      puts "===== Warnings ====="
      pp stories_creator.warnings
    end
  end

  def self.project
    @@project
  end

  private

  def self.set_project(project)
    @@project = project
  end
end
