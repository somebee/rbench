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

    def to_s(val = title)
      RBench.formatter.column(self, val)
    end
  end
end
