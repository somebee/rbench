require 'pathname'
require 'benchmark'

dir = Pathname(__FILE__).dirname.expand_path + 'rbench/'

require dir + 'runner'
require dir + 'column'
require dir + 'group'
require dir + 'report'
require dir + 'summary'

module RBench
  def self.prepare(&block)
    Runner.new
  end
  
  def self.run(times=1, &block)
    Runner.new.run(times,&block)
  end
end
