require 'csv'
require 'ehpt/base'
require 'ehpt/create_story'

class Ehpt
  class CreateStories < Base
    attr_reader :csv_content, :project

    ARRAY_TYPE_ATTRIBUTES = %w[ labels tasks pull_requests branches blockers comments reviews ]

    INT_ARRAY_TYPE_ATTRIBUTES = %w[ owner_ids label_ids follower_ids ]

    INT_TYPE_ATTRIBUTES = %w[ project_id requested_by_id before_id after_id integration_id ]

    FLOAT_TYPE_ATTRIBUES = %w[ estimate ]

    def initialize(csv_content, project)
      @csv_content = csv_content
      @project = project
      super
    end

    def call
      validate_csv_content!
      create_stories unless error?
      puts "Done"
    rescue StandardError => e
      errors << e.message
    end

    private

    def validate_csv_content!
      if csv_content.blank?
        @errors << 'CSV content is empty'
      end
      puts "Read CSV done"
    end

    def create_stories
      CSV.parse(csv_content, headers: true) do |row|
        story_attrs = create_story_attributes(row)
        story_creator = Ehpt::CreateStory.new(project, story_attrs)
        story_creator.call
        if story_creator.error?
          @errors = @errors.concat(story_creator.errors)
        end
      end
    end

    def create_story_attributes(row)
      story_attrs = row.to_h.compact
      story_attrs.each do |key, value|
        story_attrs[key] = value.to_i if INT_TYPE_ATTRIBUTES.include?(key)
        story_attrs[key] = value.to_f if FLOAT_TYPE_ATTRIBUES.include?(key)
        story_attrs[key] = value.split(',') if ARRAY_TYPE_ATTRIBUTES.include?(key)
        story_attrs[key] = value.split(',').map(&:to_i) if INT_ARRAY_TYPE_ATTRIBUTES.include?(key)
      end
      story_attrs
    end
  end
end
