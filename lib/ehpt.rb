require 'csv'
require 'ehpt/get_project'
require 'ehpt/create_stories'

class Ehpt
  attr_reader :csv_file, :project

  def initialize(csv_file, token, project_id)
    @csv_file = csv_file
    @project = get_project_by(token, project_id)
  end

  def call
    stories_creator = Ehpt::CreateStories.new(csv_file, project)
    stories_creator.call
    puts "Done"
    if stories_creator.error?
      puts "Errors: #{stories_creator.errors}"
    end
  end

  private

  def get_project_by(token, project_id)
    project_getter = Ehpt::GetProject.new(token, project_id)
    project_getter.call

    if project_getter.error?
      raise StandardError, project_getter.errors
    end

    puts "Found project: #{project_getter.data.name}"
    project_getter.data
  end
end
