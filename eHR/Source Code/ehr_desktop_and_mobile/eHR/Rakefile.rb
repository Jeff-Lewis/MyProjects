require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:all) do |t|
  t.cucumber_opts = "features -t @all"
end

Cucumber::Rake::Task.new(:s2_electronic_notes) do |t|
  t.cucumber_opts = "features -t @s2_electronic_notes"
end

Cucumber::Rake::Task.new(:s2_demographics) do |t|
  t.cucumber_opts = "features -t @s2_demographics"
end
