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
      puts "Created story: #{@story.name}"
    rescue StandardError => e
      errors << e.message
    end

    private

    def create_story
      @story = project.create_story(story_attrs)
    end

    def prefix_story_name_with_id
      @story.name = [@story.id.to_s.split(//).last(3).join, @story.name].join(' - ')
      @story.save
    end
  end
end
