#$scenario_count = 0
Before do |scenario|
  $scenario_count += 1
  puts "---------------- before (#{$scenario_count.to_s})"
  case scenario
    when Cucumber::Ast::Scenario
      @feature_name = scenario.feature.name
    when Cucumber::Ast::OutlineTable::ExampleRow
      @feature_name = scenario.scenario_outline.feature.name
  end
  puts("Test Feature         : " + @feature_name)
  case scenario
    when Cucumber::Ast::Scenario
      @scenario_name = scenario.name
    when Cucumber::Ast::OutlineTable::ExampleRow
      @scenario_name = scenario.scenario_outline.name
  end
  puts("Test Scenario        : " + @scenario_name)
  puts("Test tag(s)          : " + scenario.source_tag_names.to_s)
  @step_count = 0
end
AfterStep do |scenario|
  @step_count += 1
  puts "---------------- after step (#{@step_count.to_s})"
end

After do |scenario|
  puts "---------------- after (#{$scenario_count.to_s})"
end

at_exit do
  puts "------------- at_exit"
end