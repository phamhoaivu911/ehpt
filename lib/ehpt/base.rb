class Ehpt
  class Base
    attr_reader :data, :errors

    def self.call(*args)
      new(*args).call
    end

    def initialize(*args)
      @data = nil
      @errors = []
    end

    def success?
      errors.empty?
    end

    def error?
      !success?
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
  end
end
