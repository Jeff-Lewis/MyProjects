=begin
  *Name             : LoginPage
  *Description      : class that launches the url and login to the website
  *Author           : Gomathi
  *Creation Date    : 19/08/2014
  *Modification Date:
=end

module EHR
  class LoginPage
    include PageObject
    include PageUtils

    expected_title "DR SYSTEMS - Meaningful Use EHR"

    text_field(:text_user_name,       :id    => "UserName")
    text_field(:text_pass_word,       :id    => "Password")
    button(:button_enter,             :value => "ENTER")
    checkbox(:check_emergency_access, :id    => "EmergencyAcess")
    div(:div_error_message,           :id    => "error")

    # Description    : automatically invoked when page class object is created
    #
    def initialize_page
      navigate_to(DESKTOP_APP_URL)     # launches the URL in the current browser
      wait_for_page_load       # waits until page title is visible
      has_expected_title?      # throws error if the page does not have the expected_title
    end

    # Description    : login to the website using valid username and password
    # Author         : Gomathi
    #
    def login
      begin
        wait_for_object(text_user_name_element, "Failure in finding user name field")
        self.text_user_name = $username
        self.text_pass_word = $password
        # sometimes the user name filled is not filled in mobile automation
        tmp_user_name = self.text_user_name
        tmp_password = self.text_pass_word
        if (tmp_user_name.nil? || tmp_user_name.empty?) || (tmp_password.nil? || tmp_password.empty?)
          self.text_user_name = $username
          self.text_pass_word = $password
        end
        click_on(button_enter_element)
        raise "Error - #{div_error_message_element.text} (#{$username}/#{$password})" if div_error_message_element.exists? && div_error_message_element.visible? && div_error_message_element.text != ""
      rescue Exception => ex
        if ex.message.downcase.include? "element is not clickable at point"
          self.execute_script("fnCheckAcess();")  # javascript method for logging into application
        else
          $log.error("Error while logging into desktop web application : #{ex}")
          exit
        end
      end
    end

  end
end