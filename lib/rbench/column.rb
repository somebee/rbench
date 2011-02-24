module RBench
  class Column
    attr_accessor :name, :title, :width, :compare, :default

    def initialize(runner, name, options = {})
      @runner  = runner
      @name    = name
      @title   = options[:title] || (@name == :times ? "" : @name.to_s.upcase)
      @width   = options[:width] || [@title.length,7].max
      @compare = options[:compare]
      @default = @compare ? @compare : options[:default]
    end

    def formatter
      @formatter ||= RBench.formatter.new(@runner, self)
    end

    def to_s(val = title)
      self.formatter.column(val)
    end
  end
end
