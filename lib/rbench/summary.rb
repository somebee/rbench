module RBench
  class Summary
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
      # maybe add convenience-method to group to. group == runner really.
      items = (@group ? @group.items & @runner.reports : @runner.reports)
      
      rows = items.map{|item| item.cells.values_at(*@runner.columns.map{|c|c.name}) }
      rows = rows.pop.zip(*rows)

      @runner.columns.each_with_index do |c,i|
        if c.compare
          value,comparisons = 0,0
          items.each do |item|
            v1,v2 = *item.cells.values_at(*c.compare)
            if v1.kind_of?(Numeric) && v2.kind_of?(Numeric) && v1 != 0 && v2 != 0
              value += v1 / v2
              comparisons += 1
            end
          end
          @cells[c.name] = [value,comparisons] if comparisons > 0
        elsif c.name != :times
          @cells[c.name] = rows[i].compact.select{|r| r.kind_of?(Numeric)}.inject(0){|tot,v| tot += v.to_f }
        end
      end
      
      puts to_s
    end
    
    def to_s
      out = ""
      out << @runner.separator(nil,"=") + @runner.newline unless @group
      out << "%-#{@runner.desc_width}s" % name
      @runner.columns.each do |column|
        value = @cells[column.name]
        out << column.to_s( value )
      end
      out << @runner.newline
    end
  end
end