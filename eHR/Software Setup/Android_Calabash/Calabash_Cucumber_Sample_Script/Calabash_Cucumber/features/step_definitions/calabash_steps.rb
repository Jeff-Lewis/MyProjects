require 'calabash-android/calabash_steps'

When /^I enter login credentials$/ do
  #wait_for_elements_exist( ["label text:'Enter your GitHub credentials'"], :timeout => 20)
  puts "sleeping"
  sleep 5
  str_email = "profchan2k15@gmail.com"
  str_password = "chan123@1"
  query("EditText id:'githubEmail'", {:setText => str_email})
  query("EditText id:'githubPassword'", {:setText => str_password})
end
