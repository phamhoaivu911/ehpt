module Ehpt
  class CreateStories < Base
    attr_reader :csv_file

    def initialize(csv_file)
      @csv_file = csv_file
      super
    end

    def call
      validate_csv_file!
      create_stories unless error?
    rescue StandardError => e
      add_error(e.message)
    end

    private

    def validate_csv_file!
      if File.extname(csv_file) != '.csv'
        add_error('Input file must be a csv file' )
      end
      add_error('CSV content is empty') if File.zero?(csv_file)
    end

    def create_stories
      CSV.foreach(csv_file, headers: true) do |row|
        story_attrs = create_story_attributes(row)

        next if error?

        story_creator = Ehpt::CreateStory.new(story_attrs)
        story_creator.call

        if story_creator.success?
          puts "Created story: #{story_creator.data.name}"
        else
          add_error({
            row: row.to_h,
            errors: story_creator.errors
          })
        end
      end
    end

    def create_story_attributes(row)
      attr_creator = Ehpt::CreateStoryAttributes.new(row)
      attr_creator.call

      add_warning(attr_creator.warnings) if attr_creator.warning?

      if attr_creator.error?
        add_error(attr_creator.errors)
        return
      end

      attr_creator.data
    end
  end
end
