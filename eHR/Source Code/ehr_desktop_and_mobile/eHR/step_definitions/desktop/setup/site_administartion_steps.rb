# Description      : step definitions for steps related to Site Administration
# Author           : Gomathi

# When "medication reconciliation" is "removed" from compliance check
When /^"([^"]*)" is "([^"]*)" (?:from|to) compliance check$/ do |str_option, str_action|
  on(EHR::MasterPage).select_menu_item(SITE_ADMINISTRATION)
  on(EHR::MasterPage).div_copy_right_element.scroll_into_view rescue Exception
  on(EHR::SiteAdministration) do |page|
    if str_option.downcase == "medication reconciliation"
      if str_action.downcase == "removed"
        page.check_check_reconciliation_not_require_for_compliance if !page.check_reconciliation_not_require_for_compliance_checked?
      elsif str_action.downcase == "added"
        page.uncheck_check_reconciliation_not_require_for_compliance if page.check_reconciliation_not_require_for_compliance_checked?
      end
      click_on(page.button_update_org_details_element)
      raise "Organization details not updated successfully" if !is_text_present(page, "Organization details updated successfully", 20)
      if page.check_reconciliation_not_require_for_compliance_checked? && str_action.downcase == "removed"
        $log.success("#{str_option.capitalize} is removed from compliance check")
      elsif !page.check_reconciliation_not_require_for_compliance_checked? && str_action.downcase == "added"
        $log.success("#{str_option.capitalize} is added to compliance check")
      else
        raise "#{str_option.capitalize} is not #{str_action.downcase == "removed" ? 'removed from' : 'added to'} compliance check"
      end
    else
      raise "Invalid input for str_option : #{str_option}"
    end
  end
end

# Given a User is created
Given /^a User is created$/ do
  on(EHR::MasterPage).select_menu_item(SITE_ADMINISTRATION)
  click_on(on(EHR::SiteAdministration).link_users_and_groups_element)
  sleep 3
  on(EHR::SiteAdministration).execute_script("LoadGoupUserIndex();") if !is_text_present(on(EHR::SiteAdministration), "User List", 5)
  on(EHR::UsersAndGroups).create_admin
end