# Description    : step definitions for steps related to Login
# Author         : Chandra sekaran

# Given a "non EP" user is logged in "mobile" web application
Given /^a "([^"]*)" user is logged in "([^"]*)" web application$/ do |str_role, str_platform|
  case str_role.downcase
    when "non ep"
      $username = $obj_yml.get_value("application/#{BOX}/#{PROFILE}/login_credentials/non_ep/user_name")         # get the credential hash
      $password = $obj_yml.get_value("application/#{BOX}/#{PROFILE}/login_credentials/non_ep/password")
    when "stage1 ep"
      $username = $obj_yml.get_value("application/#{BOX}/#{PROFILE}/login_credentials/stage1_ep/user_name")
      $password = $obj_yml.get_value("application/#{BOX}/#{PROFILE}/login_credentials/stage1_ep/password")
    when "stage2 ep"
      $username = $obj_yml.get_value("application/#{BOX}/#{PROFILE}/login_credentials/stage2_ep/user_name")         # get the credential hash
      $password = $obj_yml.get_value("application/#{BOX}/#{PROFILE}/login_credentials/stage2_ep/password")
    else
      raise "Invalid login person : #{str_role}"
  end
  $user = str_role.downcase
  if str_platform.downcase == "desktop"
    on(EHR::DashboardPage).logout
    EHR::BrowserSettings.launch_url(DESKTOP_APP_URL)
    on(EHR::LoginPage).login
    on(EHR::MasterPage).verify_login
    $bool_desktop_session = true
  elsif str_platform.downcase == "mobile"
    if $bool_desktop_session
      on(EHR::MasterPage).logout
      $bool_desktop_session = false
    end
    if !on(EHR::DashboardPage).is_session_active     # checks if an user is already logged in
      visit(EHR::MobileLoginPage).login           # creates a new session
      on(EHR::MasterPage).verify_login
    end
  else
    raise "Invalid platform name : #{str_platform}"
  end
end