=begin
  *Name               :  UsersAndGroups
  *Description        : class that holds methods for creating user accounts
  *Author             : Chandra sekaran
  *Creation Date      : 02/03/2015
  *Modification Date  :
=end

module EHR
  class UsersAndGroups
    include PageObject
    include PageUtils

    # Groups
    # Admin group
    span(:span_admin_group,                           :id    =>  "ygtvlabelel2")

    # Admin user details
    text_field(:textfield_user_name,                  :id    =>  "UserName")
    text_field(:textfield_contact_name,               :id    =>  "ContactPersonName")
    button(:button_import_contact_name,               :value =>  "...")
    text_field(:textfield_password,                   :id    =>  "Password")
    text_field(:textfield_confirm_password,           :id    =>  "ConfirmPassword")
    select_list(:select_type,                         :id    =>  "TypeID")
    select_list(:select_language,                     :id    =>  "LanguageID")
    select_list(:select_preferred_contact,            :id    =>  "PrefContact")
    text_field(:textfield_email,                      :id    =>  "Email")
    text_field(:textfield_mobile,                     :id    =>  "Mobile")
    select_list(:select_status,                       :id    =>  "Status")
    button(:button_add_new_user,                      :id    =>  "lnkCreateUser-button")
    button(:button_cancel,                            :id    =>  "lnkCloseUser-button")

    # Contact iframe
    div(:div_contact_person_iframe,                   :id    =>  "create_patient")
    div(:div_contact_person_list,                     :id    =>  "cntContactPersonList")
    text_field(:textfield_first_name,                 :id    =>  "ContactFirstName")
    text_field(:textfield_last_name,                  :id    =>  "ContactLastName")
    button(:button_search_contact,                    :value =>  "Search")
    button(:button_new_contact,                       :id    =>  "lnkEditPatientDemo-button")
    table(:table_contact_person_list,                 :id    =>  "//div[@id='cntContactPersonList']/table")
    link(:link_close_contact_person_iframe,           :xpath =>  "//div[@id='DivPopUp']/a")
    checkbox(:checkbox_select_contact_person,         :class =>  "yui-dt-checkbox")

    # Add new contact iframe
    div(:div_add_new_contact,                         :id    =>  "divCreateNewContact")
    text_field(:textfield_contact_first_name,         :id    =>  "AddContactFirstName")
    text_field(:textfield_contact_middle_name,        :id    =>  "MiddleName")
    text_field(:textfield_contact_last_name,          :id    =>  "AddContactLastName")
    text_field(:textfield_contact_display_name,       :id    =>  "DispalyName")
    text_field(:textfield_contact_email_id,           :id    =>  "AddContactEmail")
    text_field(:textfield_contact_mobile,             :id    =>  "AddContactMobile")
    text_field(:textfield_contact_phone,              :id    =>  "AddContactPhone")
    button(:button_create_new_contact,                :value =>  "Create")
    button(:button_close_new_contact,                 :id    =>  "lnkCloseCreateVisit-button")
    link(:link_close_add_new_contact_iframe,          :xpath =>  "//div[@id='DivContactPopUp']/a")

    # Associate EP
    div(:div_add_associate_ep,                        :id    =>  "divCreateNewGroup1")
    link(:link_close_add_associate_ep_iframe,         :xpath =>  "//div[@id='DivPopUp']/a")

    # Description          : invoked automatically when the class object is created
    # Author               : Chandra sekaran
    #
    def initialize_page
      create_hash
    end

    # Description          : creates a hash for indexing columns in Contact person table
    # Author               : Chandra sekaran
    #
    def create_hash
      @hash_contact_person_table_header = {
          :SELECT => 1,
          :FIRST_NAME => 2,
          :LAST_NAME => 3,
          :EMAIL_ADDRESS => 4,
          :MOBILE => 5
      }
    end

    # Description          : creates a new admin user
    # Author               : Chandra sekaran
    # Arguments            :
    #   admin_data_node    : test data node
    #
    def create_admin(admin_data_node = "admin_data")
      begin
        click_on(span_admin_group_element)
        div_copy_right_element.scroll_into_view rescue Exception
        hash_admin = set_scenario_based_datafile(ADMIN_GROUP)

        str_user_name = hash_admin[admin_data_node]["textfield_user_name"] + Time.now.strftime("%Y%m%d%H%M%S")
        self.textfield_user_name = str_user_name

        click_on(button_import_contact_name_element)
        wait_for_object(div_contact_person_iframe_element, "Failure in finding Contact Person iframe")
        link_close_contact_person_iframe_element.send_keys(:arrow_down) rescue Exception
        click_on(button_new_contact_element)
        str_last_name = create_new_contact
        search_contact("last name", str_last_name)

        #table_contact_person_list_element.checkbox_element(:xpath => "#{$xpath_tbody_data_first_row}/td[#{@hash_contact_person_table_header[:SELECT]}]/div/input").click
        checkbox_select_contact_person_element.click
        #raise "Failure in selecting contact person" if div_contact_person_iframe_element.visible?

        self.textfield_password = hash_admin[admin_data_node]["textfield_password"]
        self.textfield_confirm_password = hash_admin[admin_data_node]["textfield_confirm_password"]
        select_type_element.select(hash_admin[admin_data_node]["select_type"])
        select_language_element.select(hash_admin[admin_data_node]["select_language"])
        select_preferred_contact_element.select(hash_admin[admin_data_node]["select_preferred_contact"])
        self.textfield_mobile = hash_admin[admin_data_node]["textfield_mobile"]
        select_status_element.select(hash_admin[admin_data_node]["select_status"])
        click_on(button_add_new_user_element)

        wait_for_object(div_add_associate_ep_element, "Failure in finding add Associate EP iframe")
        click_on(link_close_add_associate_ep_iframe_element)

        raise "Failure in creating new Admin" if !is_text_present(self, "User created successfully", 2)
        $username = str_user_name
        $password = hash_admin[admin_data_node]["textfield_password"]
        $log.success("New Admin created successfully (#{$username}/#{$password})")
      rescue Exception => ex
        $log.error("Error while creating new Admin : #{ex}")
        exit
      end
    end

    # Description          : creates a new contact
    # Author               : Chandra sekaran
    # Arguments            :
    #   contact_data_node  : test data node
    # Return Arguments     :
    #   str_timestamp      : last name of the contact person
    #
    def create_new_contact(contact_data_node = "contact_data")
      begin
        wait_for_object(div_add_new_contact_element, "Failure in finding Add new contact iframe")
        hash_contact = set_scenario_based_datafile(NEW_CONTACT)

        str_timestamp = Time.now.strftime("%Y%m%d%H%M%S")
        self.textfield_contact_first_name = hash_contact[contact_data_node]["textfield_contact_first_name"]
        self.textfield_contact_last_name = str_timestamp
        self.textfield_contact_display_name = "contact " + str_timestamp
        self.textfield_contact_email_id = hash_contact[contact_data_node]["textfield_contact_email_id"]
        self.textfield_contact_mobile = hash_contact[contact_data_node]["textfield_contact_mobile"]
        self.textfield_contact_phone = hash_contact[contact_data_node]["textfield_contact_phone"]

        click_on(button_create_new_contact_element)
        raise "Failure in adding new Contact" if !is_text_present(self, "Contact added successfully", 5)
        click_on(button_close_new_contact_element)
        str_timestamp   # return the last name
      rescue Exception => ex
        $log.error("Error while creating new Contact : #{ex}")
        exit
      end
    end

    # Description          : searches for contact based on given filter(s)
    # Author               : Chandra sekaran
    # Arguments            :
    #   str_filter         : filter name
    #   str_value1         : filter value for first filter
    #   str_value2         : filter value for second filter
    #
    def search_contact(str_filter, str_value1, str_value2 = "")
      begin
        if str_filter.downcase == "first name"
          self.textfield_last_name = str_value1
        elsif str_filter.downcase == "last name"
          self.textfield_last_name = str_value1
        elsif str_filter.downcase == "both"
          self.textfield_last_name = str_value1
          self.textfield_last_name = str_value2
        else
          raise "Invalid filter : #{str_filter}"
        end
        click_on(button_search_contact_element)
        sleep 1 until !is_text_present(self, "Loading...", 1)
        raise "No record found for given filter" if is_text_present(self, "No records found", 2)
      rescue Exception => ex
        $log.error("Error while searching for Contact with #{str_filter} '#{str_value1}' : #{ex}")
        exit
      end
    end

  end
end