require 'csv'
require 'ehpt/get_project'
require 'ehpt/get_csv_content'
require 'ehpt/create_stories'

class Ehpt
  attr_reader :csv_content, :project

  def initialize(csv_file, token, project_id)
    @csv_content = get_csv_content_from(csv_file)
    @project = get_project_by(token, project_id)
  end

  def call
    stories_creator = Ehpt::CreateStories.new(csv_content, project)
    stories_creator.call
    if stories_creator.error?
      raise StandardError, stories_creator.errors
    end
  end

  private

  def get_csv_content_from(csv_file)
    csv_content_getter = Ehpt::GetCsvContent.new(csv_file)
    csv_content_getter.call

    if csv_content_getter.error?
      raise StandardError, csv_content_getter.errors
    end

    csv_content_getter.data
  end

  def get_project_by(token, project_id)
    project_getter = Ehpt::GetProject.new(token, project_id)
    project_getter.call

    if project_getter.error?
      raise StandardError, project_getter.errors
    end

    puts "Found project #{project_getter.data.name}"
    project_getter.data
  end
end
