# encoding: utf-8

module RBench
  class Formatter
    def initialize(runner, instance)
      @runner, @instance = runner, instance
    end

    def newline
      "\n"
    end

    def width
      @instance.width
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

    def runner(*)
      raise NotImplementedError.new("You have to redefine #{self.class}#runner")
    end
  end
end
