require 'csv'

module Ehpt
  class CreateStories < Base
    attr_reader :csv_content, :project

    def initialize(csv_content, project)
      @csv_content = csv_content
      @project = project
      super
    end

    def call
      validate_csv_content!
      create_stories unless error?
    end

    private

    def validate_csv_content!
      if csv_content.blank?
        @errors << 'CSV file is empty'
      end
    end

    def create_stories
      CSV.parse(csv_content, headers: true) do |story_attrs|
        story_creator = Ehpt::CreateStory.new(project, story_attrs)
        story_creator.call
        if story_creator.error?
          @errors = @errors.concat(story_creator.errors)
        end
      end
    end
  end
end
