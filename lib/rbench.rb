require 'pathname'
require 'benchmark'

dir = Pathname(__FILE__).dirname.expand_path + 'rbench/'

require dir + 'runner'
require dir + 'column'
require dir + 'group'
require dir + 'report'
require dir + 'summary'
require dir + 'formatter'

module RBench
  def self.run(times = 1, formatter = self.formatter, &block)
    formatter.runner = Runner.new(times)
    formatter.runner.run(&block)
    formatter.finish_run
  end

  def self.formatter
    @formatter ||= begin
      require "rbench/formatters/default"
      DefaultFormatter.new
    end
  end

  def self.formatter=(formatter)
    @formatter = formatter
  end
end
