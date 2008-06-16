module RBench
  class Runner
    attr_accessor :columns, :items, :times, :width
    
    def initialize(times)
      @width = 0
      @times = times
      @columns = []
      @items = []
    end
    
    def run(&block)
      
      # initiate all the columns, groups, reports, and summaries on top level.
      self.instance_eval(&block)
      
      # the groups has not run just yet, but when they do, we really only want
      # to make them initiate their reports, not run them (just yet)
      # when we only have two levels, _every_ report should now be initialized.
      @items.each{|item| item.prepare if item.is_a?(Group)}
      
      # We are putting the summary to the back if its there.
      @items << @items.shift if @items.first.is_a?(Summary)
      
      # if on columns were set, create a default column
      column(:results, :title => "Results") if @columns.empty?
      
      # since we are about to start rendering, we put out the column-header
      puts header
      
      # now we are ready to loop through our items and run!
      items.each { |item| item.run if item.respond_to?(:run) }
      
      # returning self so people can output it in different formats.
      self
    end
    
    def format(options={})
      @width = options.delete(:width) || @width
    end
    
    def column(name,options={})
      @columns << Column.new(self,name,options)
    end
    
    def group(name,times=nil,&block)
      @items << Group.new(self,name,times,&block)
    end
    
    def report(name,times=nil,&block)
      # create an anonymous group, or add it to the last open group.
      group(nil) unless @items.last.is_a?(Group) && !@items.last.block
      # now create the report on the last group
      @items.last.report(name,times,&block)
    end
    
    def summary(name)
      # adding the summary to the front, so it is easier to put it last later.
      @items.unshift(Summary.new(self,nil,name)) unless @items.detect{|i| i.is_a?(Summary)}
    end
    
    ##
    # convenience-methods
    ##
    
    def groups
      @items.select{|item| item.is_a?(Group) }
    end

    def reports
      # we now want _all_ reports, also those that are part of subgroups
      groups.map{|g| g.items.select{|item| item.is_a?(Report) } }.flatten
    end
    
    ##
    # for rendering text. pull out in separate module when to_xml and to_html is in place
    ##
    
    def newline
      "\n"
    end
    
    def header
      " " * desc_width + @columns.map {|c| c.to_s }.join + newline
    end
    
    def desc_width
      @desc_width ||= [items.map{|i| (i.items.map{|r| r.name} << i.name) }.flatten.map{|i| i.to_s.length}.max+8,@width-columns_width].max
    end
    
    def columns_width
      @columns.inject(0){ |tot,c| tot += (c.to_s.length) }
    end
    
    def width(value=nil)
      header.length-1
    end

    def separator(title=nil,chr="-",length=width)
      title ? chr*2 + title + chr * (width - title.length - 2) : chr * length
    end
    
    def to_s
      out = " " * desc_width + @columns.map {|c| c.to_s }.join + newline
      out << @items.map {|item| item.to_s}.join
    end
    
  end
end