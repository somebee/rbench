# encoding: utf-8

module RBench
  class DefaultFormatter < Formatter
    def summary(instance, name, group, cells)
      out = ""
      out << self.separator(nil, "=") + self.newline unless group
      out << "%-#{@runner.desc_width}s" % name
      @runner.columns.each do |column|
        value = cells[column.name]
        out << column.to_s(value)
      end
      out << self.newline
    end

    def report(instance, name, cells)
      out = "%-#{@runner.desc_width}s" % name
      @runner.columns.each do |column|
        value = cells[column.name]
        value = cells.values_at(*value) if value.is_a?(Array)
        value = nil if value.is_a?(Array) && value.compact.length != 2

        out << column.to_s(value)
      end
      out << self.newline
    end

    def group(instance, name, items)
      @runner.separator(name) << items.map { |item| item.to_s }.join
    end

    def column(instance, value)
      width = instance.width
      str = case value
        when Array      then "%#{width-1}.2f" % (value[0] / value[1]) + "x"
        when Float      then "%#{width}.3f" % value
        when Integer    then "%#{width}.0f" % value
        when TrueClass  then " " * (width / 2.0).floor + "X" + " "*(width/2.0).floor
        when String     then "%#{width}s" % (value)[0, width]
        when Object     then " " * width
      end
      return " #{(str.to_s + " " * width)[0, width]} |"
    end

    def runner_report(instance, columns, items)
      out = " " * instance.desc_width + columns.map { |c| c.to_s }.join + self.newline
      out << items.map { |item| item.to_s }.join
    end

    def separator(instance, title = nil, chr = "-", length = @runner.width)
      title ? chr * 2 + title + chr * (@runner.width - title.length - 2) : chr * length
    end

    def header(instance, columns)
      " " * instance.desc_width + columns.map { |c| c.to_s }.join + self.newline
    end
  end
end
