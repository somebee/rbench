module RBench
  class Report
    self.instance_methods.each do |m|
      send(:undef_method, m) unless m =~ /^(__|is_a?|kind_of?|inspect|instance_eval)/
    end
    
    attr_reader :name, :cells
    
    def initialize(runner, name, times=nil,&block)
      @runner = runner
      @name   = name
      @times  = (times || runner.times).ceil
      @cells  = {}
      
      # Setting the default for all cells
      runner.columns.each {|c| @cells[c.name] = c.name == :times ? "x#{@times}" : c.default }
      
      new_self = (class << self; self end)
      @runner.columns.each do |column|
        new_self.class_eval <<-CLASS
          def #{column.name}(val=nil,&block)
            @cells[#{column.name.inspect}] = block ? Benchmark.measure { @times.times(&block) }.real : val
          end
        CLASS
      end
      
      self.instance_eval(&block)
      
      puts to_s
    end
    
    def to_s
      out = "%-#{@runner.desc_width}s" % name
      @runner.columns.each do |column|
        value = @cells[column.name]
        out << column.to_s(value.is_a?(Array) ? @cells.values_at(*value) : value )
      end
      out << @runner.newline
    end
  end
end