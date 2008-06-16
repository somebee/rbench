require 'pathname'
require Pathname(__FILE__).dirname.expand_path + 'spec_helper'

TIMES = 100_000

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

puts
puts

RBench.run(TIMES) do
  
  format :width => 80

  report "Squeezing with #squeeze" do
    "abc//def//ghi//jkl".squeeze("/")
  end

  report "Squeezing with #gsub" do
    "abc//def//ghi//jkl".gsub(/\/+/, "/")
  end

  report "Splitting with #split" do
    "aaa/aaa/aaa.bbb.ccc.ddd".split(".")
  end

  report "Splitting with #match" do
    "aaa/aaa/aaa.bbb.ccc.ddd".match(/\.([^\.]*)$/)
  end
  
end

puts
puts

bench = RBench.run(TIMES) do

  column :times
  column :dm
  column :ar
  column :diff, :compare => [:dm,:ar]

  group "This is a group" do

    report "split", TIMES / 10 do
      dm { "aaa/aaa/aaa.bbb.ccc.ddd".split(".") }
      ar { "aaa//aaa//aaa.bbb.ccc.ddd.eee".split(".") }
    end
  
    report "match" do
      dm { "aaa/aaa/aaa.bbb.ccc.ddd".match(/\.([^\.]*)$/) }
      ar { "aaa//aaa//aaa.bbb.ccc.ddd.eee".match(/\.([^\.]*)$/) }
    end
    
    summary "methods (totals)" # should display total for all preceding rows within this group / scope
  
  end

  group "This is a group" do

    report "split", TIMES / 10 do
      dm { "aaa/aaa/aaa.bbb.ccc.ddd".split(".") }
      ar { "aaa//aaa//aaa.bbb.ccc.ddd.eee".split(".") }
    end
  
    report "match" do
      dm { "aaa/aaa/aaa.bbb.ccc.ddd".match(/\.([^\.]*)$/) }
      #ar { "aaa//aaa//aaa.bbb.ccc.ddd.eee".match(/\.([^\.]*)$/) }
    end
  
  end
  
  report "testing" do
    dm { "aaa/aaa/aaa.bbb.ccc.ddd".match(/\.([^\.]*)$/) }
    ar { "aaa//aaa//aaa.bbb.ccc.ddd.eee".match(/\.([^\.]*)$/) }
  end
  
  summary "Overall"

end

puts
puts

RBench.run(TIMES) do

  column :times
  column :one,  :title => "#1"
  column :two,  :title => "#2"
  column :diff, :title => "#1/#2", :compare => [:one,:two]

  group "Squeezing", 10000 do
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