module RBench
  class Runner
    attr_accessor :columns, :items, :times, :width
    
    def initialize(times)
      @width = 80
      @times = times
      @columns = []
      @items = []
    end
    
    def format(options={})
      @width = options.delete(:width) || @width
    end
    
    def column(name,options={})
      @columns << Column.new(self,name,options)
    end
    
    def group(name,&block)
      puts columns_line if @items.empty?
      @items << Group.new(self,name,&block)
    end
    
    def report(name,times=nil,&block)
      group(nil) unless @items.last.is_a?(Group) && @items.last.anonymous?
      @items.last.report(name,times,&block)
    end
    
    def summary(name)
      @items << Summary.new(self,name,reports)
    end

    def groups
      @items.reject{|i| !i.is_a?(Group)}
    end
    
    def reports
      groups.map{|i| i.reports.reject{|r| !r.is_a?(Report) } }.flatten
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
      out << @items.map {|item| item.to_s}.join
    end
    
  end
end