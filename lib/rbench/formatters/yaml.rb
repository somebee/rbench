# encoding: utf-8

require "yaml"
require "rbench/formatters/default"

# @example:
#   file = File.new("results.yml", "w")
#   RBench.formatter = RBench::YAMLFormatter.new(file)
module RBench
  class YAMLFormatter < DefaultFormatter
    def initialize(stream)
      @stream = stream
    end

    def setup
      # We can't use #finish_run, because one formatter
      # can be reused accross multiple RBench.run blocks,
      # and in this case we want to accumulate all the
      # results and write when everything finished.
      at_exit do
        self.write_results
      end
    end

    def results
      @results ||= Hash.new
    end

    def write_results
      @stream.write(self.results.to_yaml)
    end

    def report(instance, name, cells)
      self.results[name] = cells
      super(instance, name, cells)
    end
  end
end
