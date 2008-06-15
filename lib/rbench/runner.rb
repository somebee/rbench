module RBench
  class Runner
    attr_accessor :columns, :groups, :reports, :times, :width
    
    def initialize(times)
      @width = 80
      @times = times
      @columns = []
      @groups = []
      @reports = []
      @items = []
    end
    
    def format(options={})
      @width = options.delete(:width) || @width
    end
    
    def column(name,options={})
      @columns << Column.new(self,name,options)
    end
    
    def group(name,options={},&block)
      puts columns_line if @items.empty?
      @groups << Group.new(self,name,options,&block)
      @items << @groups.last
    end
    
    def report(name,times=nil,&block)
      puts columns_line + separator if @items.empty?
      @reports << Report.new(self,name,times,&block)
      @items << @reports.last
    end
    
    def summary(name)
      @reports << Summary.new(self,name,@reports.reject{|r| r.is_a?(Summary)})
    end
    
    def run(&block)
      self.instance_eval(&block)
      self
    end
    
    def desc_width
      width - columns_width
    end
    
    def columns_width
      @columns.inject(0){ |tot,c| tot += (c.to_s.length) }
    end
    
    def width(value=nil)
      value ? @width = value : @width
    end

    def separator(title=nil,chr="-",length=width)
      separator_line = title ? chr*2 + title + chr * (width - title.length - 2) : chr * length
      puts separator_line
      @items << separator_line
      return separator_line
    end
    
    def newline
      "\n"
    end
    
    def columns_line
      " " * desc_width + @columns.map {|c| c.to_s }.join + newline
    end
    
    def to_s
      out = " " * desc_width + @columns.map {|c| c.to_s }.join + newline
      out << separator unless @items.first.is_a?(Group)
      
      @items.each_with_index do |line,i|
        out << separator if @items[i-1].is_a?(Group) && line.is_a?(Report)
        out << line.to_s
      end

      out
    end
    
  end
end