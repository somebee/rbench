# encoding: utf-8

module RBench
  class Formatter
    attr_accessor :runner
    def initialize
      self.setup if self.respond_to?(:setup)
    end

    def newline
      "\n"
    end

    def finish_run
    end

    def summary(*)
      raise NotImplementedError.new("You have to redefine #{self.class}#summary")
    end

    def report(*)
      raise NotImplementedError.new("You have to redefine #{self.class}#report")
    end

    def group(*)
      raise NotImplementedError.new("You have to redefine #{self.class}#group")
    end

    def column(*)
      raise NotImplementedError.new("You have to redefine #{self.class}#column")
    end

    def runner_report(*)
      raise NotImplementedError.new("You have to redefine #{self.class}#runner_report")
    end
  end
end
