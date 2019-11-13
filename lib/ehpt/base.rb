module Ehpt
  class Base
    attr_reader :data, :errors, :warnings

    def self.call(*args)
      new(*args).call
    end

    def initialize(*args)
      @data = nil
      @errors = []
      @warnings = []
    end

    def success?
      errors.empty?
    end

    def error?
      !success?
    end

    def warning?
      !warnings.empty?
    end

    def add_error(error)
      if error.is_a?(Array)
        error.each do |err|
          add_error(err)
        end
      else
        @errors << error
      end
    end

    def add_warning(warning)
      if warning.is_a?(Array)
        warning.each do |err|
          add_warning(err)
        end
      else
        @warnings << warning
      end
    end
  end
end
