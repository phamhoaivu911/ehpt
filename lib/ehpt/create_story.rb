module Ehpt
  class CreateStory < Base
    attr_reader :story_attrs

    def initialize(story_attrs)
      @story_attrs = story_attrs
      super
    end

    def call
      create_story
      prefix_story_name_with_id
    rescue StandardError => e
      add_error(eval(e.message)[:body])
    end

    private

    def create_story
      @data = Ehpt.project.create_story(story_attrs)
    end

    def prefix_story_name_with_id
      @data.name = [@data.id.to_s.split(//).last(3).join, @data.name].join(' - ')
      @data.save
    end
  end
end
