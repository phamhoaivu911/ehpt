module Ehpt
  class GetUserIdFromInitial < Base
    @@memberships = nil

    attr_reader :initial

    def self.memberships
      @@memberships
    end

    def self.memberships=(memberships)
      @@memberships = memberships
    end

    def initialize(initial)
      @initial = initial
      super
    end

    def call
      fetch_memberships_from_pt!

      if user.nil?
        add_error("Not found any user with initial #{initial}")
      else
        @data = user.id
      end
    rescue StandardError => e
      add_error(eval(e.message)[:body])
    end

    private

    def memberships
      self.class.memberships
    end

    def fetch_memberships_from_pt!
      self.class.memberships ||= Ehpt.project.memberships
    end

    def user
      member = memberships.find do |membership|
        membership.person.initials.downcase == initial.downcase
      end
      member && member.person
    end
  end
end
