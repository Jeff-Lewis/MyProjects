=begin
  *Name             : Demographics
  *Description      : contains all objects and methods in Demographics page
  *Author           : Gomathi
  *Creation Date    : 05/09/2014
  *Modification Date:
=end

module EHR
  module Demographics

    include PageObject
    include PageUtils

    form(:form_edit_patient,          :id    => "editpatientform")
    select_list(:select_sex,          :id    => "Gender")
    select_list(:select_ethnicity,    :id    => "Ethinicity")
    select_list(:select_language,     :id    => "Language")
    paragraph(:paragraph_race,        :id    => "p_Race")
    unordered_list(:ul_race_list,     :xpath => "//div[@class='selectBox']/ul")
    button(:button_save_demographics, :id    => "lnkEditPatientDemo-button")
    label(:label_message,             :text  => "Patient details updated successfully")
    div(:div_select_race_outer,       :class => "selectBox") #Outer")

    # description          : function to enter data to MU fields of a patient in Demographics page
    # Author               : Gomathi
    # Arguments            :
    #   str_mu_attribute   : string that denotes the MU field to be filled
    #   str_patient_node   : root node of test data for Patient
    #
    def enter_mu(str_mu_attribute, str_patient_node = "patient_data")
      begin
        wait_for_loading
        add_demographics_values(str_mu_attribute, str_patient_node)

        wait_for_object(button_save_demographics_element, "Failure in finding 'Save' button in demographics tab")
        button_save_demographics_element.scroll_into_view rescue Exception
        3.times { button_save_demographics_element.send_keys(:arrow_down) } rescue Exception if BROWSER.downcase == "chrome"
        button_save_demographics_element.focus rescue Exception
        button_save_demographics_element.click
        wait_for_loading
        raise "Failure in finding 'Patient details updated successfully' message"  if !(is_text_present(self, "Patient details updated successfully") || is_text_present(self, "Patient information updated successfully"))
      rescue Exception => ex
        $log.error("Error while entering MU fields (#{str_mu_attribute}) for a patient : #{ex}")
        exit
      end
    end

    # description    : function to enter data to Race MU field of a patient
    # Author         : Gomathi
    # Arguments      :
    #   str_race     : string that denotes data for Race
    #
    def select_race(str_race)
      begin
        sleep 1
        raise "Race field in data file is empty" if str_race.nil?
        #arr_race = str_race.split('/')
        arr_race = str_race.gsub(", ",",").split(',')

        div_select_race_outer_element.when_visible.click
        div_select_race_outer_element.fire_event("onmouseover")
        ul_race_list_element.scroll_into_view rescue Exception if !(BROWSER.downcase == "chrome")

        if str_race.downcase == "all race"
          arr_race.each do |race|
            ul_race_list_element.list_item_elements(:xpath => "./li").each do |race_list|
              race_list.focus
              if !(race_list.label_element(:xpath => ".//label").text.strip.downcase == "------------------")
                race_list.checkbox_element(:xpath => "./input").click  unless race_list.label_element(:xpath => ".//label").text.strip.downcase == "declined to state"
              end
            end
          end
        else
          arr_race.each do |race|
            ul_race_list_element.list_item_elements(:xpath => "./li").each do |race_list|
              race_list.focus
              if !(race_list.label_element(:xpath => ".//label").text.strip.downcase == "------------------")
                race_list.checkbox_element(:xpath => "./input").click  if race_list.label_element(:xpath => ".//label").text.strip.downcase == race.downcase.strip
              end
            end
          end
        end
        sleep 1
        # select the given race if the race is not selected properly
        tmp_race = paragraph_element(:id => "p_Race").text
        if tmp_race.strip.downcase.include? "select 1 or more"
          select_race(str_race)
        end
      rescue Exception => ex
        $log.error("Error while selecting race (#{str_race}) for a patient : #{ex}" )
        exit
      end
    end

    # description               : function to enter data to MU fields of a patient
    # Author                    : Gomathi
    # Arguments                 :
    #   str_mu_attribute        : string that denotes the MU field to be filled
    #   str_demographics_node   : root node of test data for demographics
    #
    def add_demographics_values(str_mu_attribute, str_demographics_node)
      hash_patient = set_scenario_based_datafile(PATIENT)
      case str_mu_attribute.downcase
        when "demographics"
          wait_for_object(select_sex_element, "Failure in finding select list for sex")
          select_sex_element.select(hash_patient[str_demographics_node]["select_sex"])
          select_ethnicity_element.select(hash_patient[str_demographics_node]["select_ethnicity"])
          select_language_element.select(hash_patient[str_demographics_node]["select_language"])
          select_race(hash_patient[str_demographics_node]["paragraph_race"])
        when "sex"
          wait_for_object(select_sex_element, "Failure in finding select list for sex")
          select_sex_element.select(hash_patient[str_demographics_node]["select_sex"])
        when "ethnicity"
          wait_for_object(select_ethnicity_element, "Failure in finding select list for ethinicity")
          select_ethnicity_element.select(hash_patient[str_demographics_node]["select_ethnicity"])
        when "preferred language"
          wait_for_object(select_language_element, "Failure in finding select list for preferred language")
          select_language_element.select(hash_patient[str_demographics_node]["select_language"])
        when "race"
          select_race(hash_patient[str_demographics_node]["paragraph_race"])
        else
          raise "Invalid MU name : #{str_mu_attribute}"
      end
    end
  end
end