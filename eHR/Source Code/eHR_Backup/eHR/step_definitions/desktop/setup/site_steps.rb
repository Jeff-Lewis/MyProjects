# Given a site is created
Given /^a site is created$/ do
  on(EHR::MasterPage).select_menu_item(SITE)
  str_site_name = on(EHR::Site).create_site
  SITE_NAME1 = str_site_name
end