require 'csv'
require 'ehpt/get_project'
require 'ehpt/create_stories'

class Ehpt
  attr_reader :csv_content, :project

  def initialize(csv_file, token, project_id)
    @csv_content = File.read(csv_file)
    @project = get_project(token, project_id)
  end

  def call
    stories_creator = Ehpt::CreateStories.new(csv_content, project)
    stories_creator.call
    if stories_creator.error?
      raise StandardError, stories_creator.errors
    end
  end

  private

  def get_project(token, project_id)
    project_getter = Ehpt::GetProject.new(token, project_id)
    project_getter.call

    if project_getter.error?
      raise StandardError, project_getter.errors
    end

    puts "Found project #{project_getter.data.name}"
    project_getter.data
  end
end
