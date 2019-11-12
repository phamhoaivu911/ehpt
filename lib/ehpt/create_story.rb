require 'ehpt/base'

class Ehpt
  class CreateStory < Base
    attr_reader :project, :story_attrs

    def initialize(project, story_attrs)
      @project = project
      @story_attrs = story_attrs
      super
    end

    def call
      create_story
      prefix_story_name_with_id
    rescue StandardError => e
      errors << e.message
    end

    private

    def create_story
      @data = project.create_story(story_attrs)
    end

    def prefix_story_name_with_id
      @data.name = [@data.id.to_s.split(//).last(3).join, @data.name].join(' - ')
      @data.save
    end
  end
end
