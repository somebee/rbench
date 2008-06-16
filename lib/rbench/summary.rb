module RBench
  class Summary < Report
    attr_reader :name, :runner, :cells, :items
    attr_accessor :lines
    
    def initialize(runner, group, name)
      @runner = runner
      @group  = group
      @name   = name
      @cells  = {}     # A hash with keys as columns, and values being the result
      @items  = []
    end
    
    def run
      #lines = @lines.reject{|l| !l.is_a?(Report)}
      
      # maybe add convenience-method to group to. group == runner really.
      items = @group ? @group.items.select{|i| i.is_a?(Report)} : @runner.reports

      @runner.columns.each do |c|
        @cells[c.name] = if c.compare
          c.compare
        elsif c.name == :times
          ""
        else
          items.inject(0){|tot,i| v = i.cells[c.name]; tot += v.kind_of?(Numeric) ? v : 0 }
        end
      end
      puts to_s
    end
  end
end