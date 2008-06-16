module RBench
  class Group
    self.instance_methods.each do |m|
      send(:undef_method, m) unless m =~ /^(__|is_a?|kind_of?|respond_to?|inspect|instance_eval)/
    end
    
    attr_accessor :name, :lines
    
    def initialize(runner, name, &block)
      @runner = runner
      @name    = name
      @lines = []
      @block = block
    end
    
    def run
      @runner.separator(@name)
      self.instance_eval(&@block) if @block
      lines.each_with_index do |line,i| 
        line.lines = @lines[0,i] if line.is_a?(Summary)
        line.run
      end
    end
    
    def anonymous?
      !!name
    end
    
    def report(name,times=nil,&block)
      report = Report.new(@runner,name,times,&block)
      @lines << report
    end
    
    def summary(name)
      summary = Summary.new(@runner,name)
      @lines << summary
    end
    
    def header
      "---" + name.to_s + "-" * (@runner.width - name.to_s.length - 3)
    end
    
    def to_s
      out = header + @runner.newline
      out << @lines.map { |r| r.to_s }.join
    end
  end
end