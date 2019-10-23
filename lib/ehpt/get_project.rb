module Ehpt
  class GetProject < Base
    attr_reader :token, :project_id

    def initialize(token, project_id)
      @token = token || ENV['PIVOTAL_TRACKER_TOKEN']
      @project_id = project_id || ENV['PIVOTAL_TRACKER_PROJECT_ID']
      super
    end

    def call
      pt_client = TrackerApi::Client.new(token: token)
      @data = pt_client.project(project_id)
    rescue StandardError => e
      @errors << e.message
    end
  end
end
