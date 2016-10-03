# Description    : step definitions for steps related to EP selection
# Author         : Chandra sekaran

# And a physician is selected "from config"
Then /^(?:a|the) physician is selected "([^"]*)"$/ do |str_source|
  on(EHR::EPPage).select_ep(str_source)
end