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
  end
end
