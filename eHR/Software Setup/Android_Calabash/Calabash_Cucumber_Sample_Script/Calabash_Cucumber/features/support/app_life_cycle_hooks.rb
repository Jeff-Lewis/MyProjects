require 'calabash-android/management/adb'
require 'calabash-android/operations'

Before do |scenario|
  puts "---------app_life_cycle_hooks-----before"
  puts "starting the server"
  start_test_server_in_background
end

After do |scenario|
  puts "---------app_life_cycle_hooks-----after"
  if scenario.failed?
    screenshot_embed
  end
  puts "stopping the server"
  shutdown_test_server
end
