module RBench
  class Report
    self.instance_methods.each do |m|
      send(:undef_method, m) unless m =~ /^(__|is_a?|kind_of?|respond_to?|hash|inspect|instance_eval|eql?)/
    end
    
    attr_reader :name, :cells
    
    def initialize(runner, group, name, times=nil,&block)
      @runner = runner
      @group  = group
      @name   = name
      @times  = (times || runner.times).ceil
      @cells  = {}
      @block  = block 
      
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
    end
    
    def run
      # runs the actual benchmarks. If there is only one column, just evaluate the block itself.
      if @runner.columns.length == 1
        @cells[@runner.columns.first.name] = Benchmark.measure { @times.times(&@block) }.real
      else
        self.instance_eval(&@block)
      end
      # puts its row now that it is complete
      puts to_s
    end
    
    def to_s
      out = "%-#{@runner.desc_width}s" % name
      @runner.columns.each do |column|
        value = @cells[column.name]
        value = @cells.values_at(*value) if value.is_a?(Array)
        value = nil if value.is_a?(Array) && value.nitems != 2
        
        out << column.to_s(value)
      end
      out << @runner.newline
    end
  end
end