module RBench
  class Summary < Report
    attr_reader :name, :runner, :cells
    
    def initialize(runner, name, reports)
      @runner = runner
      @name   = name
      @cells  = {}     # A hash with keys as columns, and values being the result
      
      runner.columns.reject{|c| c.default == :times}.each do |c|
        @cells[c.name] = reports.inject(0){|tot,r| tot += r.cells[c.name] if r.cells[c.name].kind_of?(Numeric) }
        @cells[c.name] = c.compare if c.compare
      end
      
      puts to_s
    end
  end
end