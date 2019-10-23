require 'csv'

module Ehpt
  class CreateStories < Base
    attr_reader :csv_file, :project

    def initialize(csv_file, project)
      @csv_file = csv_file
      @project = project
      super
    end

    def call
      validate_csv_file!
      create_stories unless error?
    end

    private

    def validate_csv_file!
      if csv_file.blank?
        @errors << 'CSV file is empty'
      end
    end

    def create_stories
      CSV.parse(csv_file, headers: true) do |story_attrs|
        story_creator = Ehpt::CreateStory.new(project, story_attrs)
        story_creator.call
        if story_creator.error?
          @errors = @errors.concat(story_creator.errors)
        end
      end
    end
  end
end
