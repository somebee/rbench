module RBench
  class Summary < Report
    attr_reader :name, :runner, :cells
    attr_accessor :lines
    
    def initialize(runner, name)
      @runner = runner
      @name   = name
      @cells  = {}     # A hash with keys as columns, and values being the result
      @lines = []
    end
    
    def run
      lines = @lines.reject{|l| !l.is_a?(Report)}
      puts lines.map{|l| l.cells}.flatten.inspect
      @runner.columns.reject{|c| c.default == :times}.each do |c|
        @cells[c.name] = lines.inject(0){|tot,l| tot += l.cells[c.name] if l.cells[c.name].is_a?(Numeric) }
        @cells[c.name] = c.compare if c.compare
      end
      
      puts to_s
    end
  end
end