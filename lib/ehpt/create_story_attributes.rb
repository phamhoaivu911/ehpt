module Ehpt
  class CreateStoryAttributes < Base
    attr_reader :row

    ARRAY_TYPE_ATTRIBUTES = %w[ labels tasks pull_requests branches blockers comments reviews ]

    INT_ARRAY_TYPE_ATTRIBUTES = %w[ owner_ids label_ids follower_ids ]

    INT_TYPE_ATTRIBUTES = %w[ project_id requested_by_id before_id after_id integration_id ]

    FLOAT_TYPE_ATTRIBUES = %w[ estimate ]

    def initialize(row)
      @row = row
      super
    end

    def call
      story_attrs = row.to_h.compact
      story_attrs.each do |key, value|
        story_attrs[key] = value.to_i if INT_TYPE_ATTRIBUTES.include?(key)
        story_attrs[key] = value.to_f if FLOAT_TYPE_ATTRIBUES.include?(key)
        story_attrs[key] = value.split(',') if ARRAY_TYPE_ATTRIBUTES.include?(key)
        story_attrs[key] = value.split(',').map(&:to_i) if INT_ARRAY_TYPE_ATTRIBUTES.include?(key)
      end

      if story_attrs.has_key?('requested_by')
        user_id = get_user_id_from(story_attrs.delete('requested_by'))
        story_attrs['requested_by_id'] = user_id unless user_id.nil?
      end

      if story_attrs.has_key?('owners')
        owners = story_attrs.delete('owners').split(',')
        owner_ids = owners.map { |owner| get_user_id_from(owner.strip) }.compact
        story_attrs['owner_ids'] = owner_ids unless owner_ids.empty?
      end

      @data = story_attrs
    rescue StandardError => e
      add_error({
        row: row.to_h,
        warnings: e.message
      })
    end

    private

    def get_user_id_from(initial)
      user_id_getter = Ehpt::GetUserIdFromInitial.new(initial)
      user_id_getter.call

      if user_id_getter.error?
        add_warning({
          row: row.to_h,
          warnings: user_id_getter.errors
        })
        return
      end

      user_id_getter.data
    end
  end
end
