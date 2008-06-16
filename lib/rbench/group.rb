module RBench
  class Group
    self.instance_methods.each do |m|
      send(:undef_method, m) unless m =~ /^(__|is_a?|kind_of?|respond_to?|hash|eql?|inspect|instance_eval)/
    end
    
    attr_reader :name, :items, :block, :times
    
    def initialize(runner, name, times=nil, &block)
      @runner = runner
      @name    = name
      @items = []
      @block = block
      @times = times || @runner.times
    end
    
    def prepare
      # This just loops through and spawns the reports, and the summary (if exists)
      self.instance_eval(&@block) if @block
      # Now we want to make sure that the summary is 
      @items << @items.shift if @items.first.is_a?(Summary)
    end
    
    def run
      # Put a separator with the group-name at the top. puts?
      puts @runner.separator(@name)
      # Now loop through the items in this group, and run them
      @items.each{|item| item.run}
    end

    def report(name,times=@times,&block)
      @items << Report.new(@runner,self,name,times,&block)
    end
    
    def summary(name)
      @items.unshift(Summary.new(@runner,self,name)) unless @items.detect{|i| i.is_a?(Summary)}
    end
    
    def to_s
      @runner.separator(@name) << @items.map { |item| item.to_s }.join
    end
  end
end