# Description   : step definitions for steps related to demographics tab
# Author        : Gomathi

# When patient "sex" is updated in demographics tab
When /^patient "(.*?)" is updated in demographics tab$/ do |str_mu_attribute,|
  on(EHR::MasterPage).select_tab("demographics")
  ##wait_for_loading
  on(EHR::CreatePatient).enter_mu(str_mu_attribute)
  wait_for_loading
end