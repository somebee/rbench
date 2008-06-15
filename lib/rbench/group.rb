module RBench
  class Group
    self.instance_methods.each do |m|
      send(:undef_method, m) unless m =~ /^(__|is_a?|kind_of?|inspect|instance_eval)/
    end
    
    attr_accessor :name, :reports
    
    def initialize(runner, name, &block)
      @runner = runner
      @name    = name
      @reports = []
      
      @runner.separator(@name)
      self.instance_eval(&block) if block
    end
    
    def anonymous?
      !!name
    end
    
    def report(name,times=nil,&block)
      report = Report.new(@runner,name,times,&block)
      @reports << report
    end
    
    def summary(name)
      summary = Summary.new(@runner,name,@reports.reject{|r| r.is_a?(Summary)})
      @reports << summary
    end
    
    def header
      "---" + name + "-" * (@runner.width - name.length - 3)
    end
    
    def to_s
      out = header + @runner.newline
      out << @reports.map { |r| r.to_s }.join
    end
  end
end