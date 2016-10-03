=begin
  *Name             : PatientInfoPage
  *Description      : class that holds the patient information page objects and method definitions
  *Author           : Chandra sekaran
  *Creation Date    : 21/01/2015
  *Modification Date:
=end

module EHR
  class PatientInfoPage
    include PageObject
    include PageUtils
    include MobileMasterPage

    form(:form_patient_info,                        :id       => "frmPatientInfo")

    # Patient information
    list_item(:listitem_patient_info_header,        :xpath    => "//form[@id='frmPatientInfo']/ul/li[1]")
    text_field(:textfield_last_name,                :id       => "txtLastName")
    text_field(:textfield_first_name,               :id       => "txtFirstName")
    text_field(:textfield_middle_name,              :id       => "txtMiddleName")
    text_field(:textfield_dob,                      :id       => "txtDOB")
    text_field(:textfield_patient_id,               :id       => "txtPatientID")
    text_field(:textfield_user_pin,                 :id       => "txtuserPIN")

    # Demographics
    select_list(:select_gender,                     :id       => "cmbGender")
    select_list(:select_pref_language,              :id       => "cmbLanguage")
    div(:div_race,                                  :id       => "divRacemultiWrapper") #"divRacemulti") #"divRacemultiWrapper")
    divs(:div_races,                                :xpath    => "//fieldset[@id='fldSetRace']/div/div")
    div(:div_race_popup,                            :id       => "popupControl")
    link(:link_race_popup_close,                    :xpath    => "//div[@id='popupControl']/a")
    select_list(:select_ethinicity,                 :id       => "cmbEthinicity")

    # Communication
    text_field(:textfield_email_address,            :id       => "txtEmailAddress")
    text_field(:textfield_pref_phone,               :id       => "txtPrefPhone")
    select_list(:select_pref_communication_method,  :id       => "cmbPrefCommunication")

    # Description     : function for selecting race(s)
    # Author          : Chandra sekaran
    # Argument        :
    #   str_race      : race name(s)
    #
    def select_race(str_race)
      begin
        raise "Race field in data file is empty" if str_race.nil?
        arr_race = str_race.split('/')
        #wait_for_object(div_race_popup_element, "Could not find Race popup")
        touch(div_race_element)
        arr_race.each do |race|          # for selecting one or more race(s)
          div_races_elements.each do |div_race|
            div_race.click if (div_race.text.strip.downcase == race.downcase) && !(div_race.checkbox_element(:xpath => "./input").checked?)
          end
        end
        #wait_for_image_loading
        link_race_popup_close_element.click    # close race popup
      rescue Exception => ex
        $log.error("Failure in selecting race (#{str_race}): #{ex}")
        link_race_popup_close_element.click if link_race_popup_close_element.exists?
        exit
      end
    end

    # Description        : function for filling Patient Info data
    # Author             : Chandra sekaran
    # Argument           :
    #   str_patient_node : test data node
    # Return argument    :
    #   str_patient_id   : patient ID
    #
    def enter_patient_info(str_patient_node = "patient_info")
      begin
        hash_patient_yml = set_scenario_based_datafile(PATIENT)

        # patient info
        self.textfield_last_name = hash_patient_yml[str_patient_node]["textfield_last_name"]
        self.textfield_first_name = Time.now.strftime("%H%M%S").to_s   # timestamp
        #self.textfield_middle_name = hash_patient_yml[str_patient_node]["textfield_middle_name"]    # not mandatory
        self.textfield_dob = hash_patient_yml[str_patient_node]["textfield_dob"]
        str_patient_id = self.textfield_patient_id

        listitem_patient_info_header_element.click rescue Exception   # scroll to top and click 'Next' button
        button_home_element.scroll_into_view rescue Exception
        click_next
        wait_for_image_loading

        # demographics
        #  select_gender_element.select(hash_patient_yml[str_patient_node]["select_gender"])  # not mandatory
        #  select_race(hash_patient_yml[str_patient_node]["race"])  # not mandatory
        #  select_ethinicity_element.select(hash_patient_yml[str_patient_node]["select_ethinicity"]) # not mandatory
        #  select_pref_language_element.select(hash_patient_yml[str_patient_node]["select_pref_language"])  # not mandatory
        click_next              # skip demographics
        wait_for_image_loading

        # communication
        #  self.textfield_email_address = hash_patient_yml[str_patient_node]["textfield_email_address"]  # not mandatory
        #  self.textfield_pref_phone = hash_patient_yml[str_patient_node]["textfield_pref_phone"]   # not mandatory
        #  select_pref_communication_method_element.select(hash_patient_yml[str_patient_node]["select_pref_communication_method"])   # not mandatory
        begin
          click_next             # skip communication
        rescue Exception => e
          wait_for_image_loading
          click_next #if is_text_present(self, "Communication", 3)
        end
        wait_for_image_loading

        $log.success("Patient (#{str_patient_id}) created successfully")
        $log.success("Test data : #{hash_patient_yml[str_patient_node]}")
        str_patient_id
      rescue Exception => ex
        $log.error("Failure in filling patient information : #{ex}")
        exit
      end
    end

    # Description        : function for filling Demographics data
    # Author             : Chandra sekaran
    # Argument           :
    #   str_patient_node : test data node
    #
    def enter_demographics(str_patient_node = "demographics")
      begin
        hash_patient_yml = set_scenario_based_datafile(PATIENT)
        # demographics
        select_gender_element.select(hash_patient_yml[str_patient_node]["select_gender"])
        select_race(hash_patient_yml[str_patient_node]["race"])
        select_ethinicity_element.select(hash_patient_yml[str_patient_node]["select_ethinicity"])
        select_pref_language_element.select(hash_patient_yml[str_patient_node]["select_pref_language"])
        click_next
        wait_for_image_loading
        click_previous
        wait_for_image_loading
        $log.success("Successfully updated demographics for patient #{$str_patient_id}")
        $log.success("Test data : #{hash_patient_yml[str_patient_node]}")
      rescue Exception => ex
        $log.error("Failure in filling patient demographics information : #{ex}")
        exit
      end
    end

    # Description        : function for filling Communications data
    # Author             : Chandra sekaran
    # Argument           :
    #   str_patient_node : test data node
    #
    def enter_communication(str_patient_node = "communication")
      begin
        hash_patient_yml = set_scenario_based_datafile(PATIENT)
        # communication
        self.textfield_email_address = hash_patient_yml[str_patient_node]["textfield_email_address"]
        self.textfield_pref_phone = hash_patient_yml[str_patient_node]["textfield_pref_phone"]
        select_pref_communication_method_element.select(hash_patient_yml[str_patient_node]["select_pref_communication_method"])
        click_next
        wait_for_image_loading
        $log.success("Successfully updated communication for patient #{$str_patient_id}")
        $log.success("Test data : #{hash_patient_yml[str_patient_node]}")
      rescue Exception => ex
        $log.error("Failure in filling patient communication information : #{ex}")
        exit
      end
    end

    # Description        : function for checking if the Demographics data are added
    # Author             : Chandra sekaran
    # Argument           :
    #   str_patient_node : test data node
    # Retrun argument    :
    #   bool_return      : a boolean value
    #
    def is_demographics_added(str_field = "demographics", str_patient_node = "demographics")
      begin
        bool_return = true
        if str_field.downcase == "ethnicity"
          bool_return &&= is_text_present(self, "Ethnicity", 3)
        else
          hash_patient_yml = set_scenario_based_datafile(PATIENT)
          str_data = self.select_gender
          bool_return &&= str_data.strip == hash_patient_yml[str_patient_node]["select_gender"]
          str_data = div_race_element.text.strip
          bool_return &&= str_data.strip.include? hash_patient_yml[str_patient_node]["race"]
          str_data = select_ethinicity
          bool_return &&= str_data.strip == hash_patient_yml[str_patient_node]["select_ethinicity"]
          str_data = select_pref_language
          bool_return &&= str_data.strip == hash_patient_yml[str_patient_node]["select_pref_language"]
        end
        bool_return
      rescue Exception => ex
        $log.error("Failure while checking for demographics data for patient #{$str_patient_id} : #{ex}")
        exit
      end
    end
  end
end