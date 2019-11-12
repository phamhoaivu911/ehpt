require 'ehpt/base'

class Ehpt
  class GetCsvContent < Base
    attr_reader :csv_file

    def initialize(csv_file)
      @csv_file = csv_file
      super
    end

    def call
      verify_csv_file
      @data = File.read(csv_file) unless error?
    rescue StandardError => e
      @errors << e.message
    end

    private

    def verify_csv_file
      if File.extname(csv_file) != '.csv'
        @errors << 'Input file must be a csv file'
      end
    end
  end
end
