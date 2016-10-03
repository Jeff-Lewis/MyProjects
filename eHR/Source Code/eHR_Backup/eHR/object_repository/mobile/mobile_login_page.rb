=begin
  *Name             : MobileLoginPage
  *Description      : class that launches the mobile url and login to the website
  *Author           : Chandra sekaran
  *Creation Date    : 21/01/2015
  *Modification Date:
=end

module EHR
  class MobileLoginPage
    include PageObject
    include PageUtils
    include MobileMasterPage

    text_field(:text_org_code,        :id        => "txtOrgCode")
    text_field(:text_user_name,       :id        => "txtUserName")
    text_field(:text_pass_word,       :id        => "txtPassword")
    link(:link_login,                 :id        => "btnLogin")

    # Description    : automatically invoked when page class object is created
    # Author         : Chandra sekaran
    #
    def initialize_page
      navigate_to(MOBILE_APP_URL)     # launches the URL in the current browser
    end

    # Description    : login to mobile website using valid organization code, username and password
    # Author         : Chandra sekaran
    #
    def login
      begin
        wait_for_object(text_org_code_element, "Failure in finding Organization code field")
        self.text_org_code = ORGANIZATION_CODE
        self.text_user_name = $username
        self.text_pass_word = $password
        touch(link_login_element)
      rescue Exception => ex
        $log.error("Error while logging into mobile application : #{ex}")
        exit
      end
    end

  end
end