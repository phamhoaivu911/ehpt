require 'csv'

class Ehpt
  attr_reader :csv_file, :project

  def initialize(csv_file, token, project_id)
    @csv_file = csv_file
    @project = get_project(token, project_id)
  end

  def call
    stories_creator = Ehpt::CreateStories.new(csv_file, project)
    stories_creator.call
    if stories_creator.error?
      raise 'Create stories error'
    end
  end

  private

  def get_project(token, project_id)
    project_getter = Ehpt::GetProject.new(token, project_id)
    project_getter.call

    if project_getter.error?
      raise 'Get project error'
    end

    project_getter.data
  end
end
