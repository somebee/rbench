rbench
======

== What is RBench?

Library for generating nice ruby-benchmarks in several formats.
Only text-output is available atm.

Heavily inspired by benchwarmer. Much love.

== Usage

require "rubygems"
require "rbench"

# Choose how many times you want to repeat each benchmark.
# This can be overridden on specific reports, if needed.
TIMES = 100_000

# A relatively simple benchmark:
RBench.run(TIMES) do
  
  column :one
  column :two

  report "Squeezing with #squeeze" do
    one { "abc//def//ghi//jkl".squeeze("/") }
    two { "abc///def///ghi///jkl".squeeze("/") }
  end

  report "Squeezing with #gsub" do
    one { "abc//def//ghi//jkl".gsub(/\/+/, "/") }
    two { "abc///def///ghi///jkl".gsub(/\/+/, "/") }
  end

  report "Splitting with #split" do
    one { "aaa/aaa/aaa.bbb.ccc.ddd".split(".") }
    two { "aaa//aaa//aaa.bbb.ccc.ddd.eee".split(".") }
  end

  report "Splitting with #match" do
    one { "aaa/aaa/aaa.bbb.ccc.ddd".match(/\.([^\.]*)$/) }
    two { "aaa//aaa//aaa.bbb.ccc.ddd.eee".match(/\.([^\.]*)$/) }
  end
  
end 

# The benchmark above will output the following:
                                                                 ONE |     TWO |
--------------------------------------------------------------------------------
Squeezing with #squeeze                                        0.122 |   0.118 |
Squeezing with #gsub                                           0.274 |   0.271 |
Splitting with #split                                          0.349 |   0.394 |
Splitting with #match                                          0.238 |   0.291 |


# Now onto a benchmark that utilizes a some more stiff.
RBench.run(TIMES) do

  format :width => 65

  column :times
  column :one,  :title => "#1"
  column :two,  :title => "#2"
  column :diff, :title => "#1/#2", :compare => [:one,:two]

  group "Squeezing" do
    report "with #squeeze" do
      one { "abc//def//ghi//jkl".squeeze("/") }
      two { "abc///def///ghi///jkl".squeeze("/") }
    end
    report "with #gsub" do
      one { "abc//def//ghi//jkl".gsub(/\/+/, "/") }
      two { "abc///def///ghi///jkl".gsub(/\/+/, "/") }
    end
    
    summary "all methods (totals)"
  end
 
  group "Splitting" do
    report "with #split" do
      one { "aaa/aaa/aaa.bbb.ccc.ddd".split(".") }
      two { "aaa//aaa//aaa.bbb.ccc.ddd.eee".split(".") }
    end
    report "with #match", TIMES / 100 do
      one { "aaa/aaa/aaa.bbb.ccc.ddd".match(/\.([^\.]*)$/) }
      two { "aaa//aaa//aaa.bbb.ccc.ddd.eee".match(/\.([^\.]*)$/) }
    end
  end
  
end

# The benchmark above will output the following:
                                  |      #1 |      #2 |   #1/#2 |
--Squeezing------------------------------------------------------
with #squeeze             x100000 |   0.122 |   0.117 |   1.04x |
with #gsub                x100000 |   0.267 |   0.279 |   0.96x |
all methods (totals)              |   0.390 |   0.396 |   0.98x |
--Splitting------------------------------------------------------
with #split               x100000 |   0.341 |   0.394 |   0.87x |
with #match                 x1000 |   0.002 |   0.003 |   0.82x |


