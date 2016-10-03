=begin
  *Name             : CreateEP
  *Description      : Class that contains all objects and methods in EP creation page
  *Author           : Gomathi
  *Creation Date    : 27/10/2014
  *Modification Date:
=end

module EHR
  class CreateEP

    include PageObject
    include PageUtils
    include Pagination

    # Objects present in new EP creation page in Client side
    div(:div_physician,                        :id         =>  "PhysicianList")
    text_field(:textfield_search_last_name,    :id         =>  "Search")
    button(:button_search,                     :class      =>  "search-lens-textbox-button")
    button(:button_new_physician,              :id         =>  "AddPhy-button")
    select_list(:select_view,                  :id         =>  "ddlView")

    # Physician list table
    div(:div_physician_list,                   :id         =>  "physician_div")
    table(:table_physician_list,               :xpath      =>  "//div[@id='physician_div']/table")

    # Eligible Professional
    div(:div_EP_page,                          :class      =>  "content_container")
    checkbox(:check_internal_physician,        :id         =>  "IsInternalPhysician")
    select_list(:select_title,                 :id         =>  "Title")
    text_field(:textfield_last_name,           :id         =>  "LastName")
    text_field(:textfield_first_name,          :id         =>  "FirstName" )
    text_field(:textfield_middle_or_initail,   :id         =>  "MiddleOrInitail")
    text_field(:textfield_suffix,              :id         =>  "Suffix")
    text_field(:textfield_address1,            :id         =>  "Address")
    text_field(:textfield_address2,            :id         =>  "Address1")
    text_field(:textfield_city,                :id         =>  "City")
    select_list(:select_state,                 :id         =>  "ddlPhysicianState")
    select_list(:select_county,                :id         =>  "Address1County")
    text_field(:textfield_NPI,                 :id         =>  "NPI")
    text_field(:textfield_speciality,          :id         =>  "Speciality")
    select_list(:select_status,                :id         =>  "Status")
    text_field(:textfield_DEA_number,          :id         =>  "DEANumber")
    text_field(:textfield_work_phone,          :id         =>  "WorkPhone")
    text_field(:textfield_home_phone,          :id         =>  "HomePhone")
    text_field(:textfield_physician_txt_zip,   :id         =>  "PhysicianTxtZip")
    select_list(:select_stage1_start_year,     :id         =>  "StageStartYear")
    checkbox(:check_provider_portal_access,    :id         =>  "ProviderPortalAccess")

    # Staff ID
    text_field(:textfield_staff_ID,            :id         =>  "StaffID")
    text_field(:textfield_staff_ID_issuer,     :id         =>  "StaffIDIssuer")
    link(:link_remove_staff_ID_list_item,      :id         =>  "removeStaffIDListItem")
    link(:link_add_dynamic_staff_ID_list,      :xpath      =>  "//div[@class='btn_add']/a")

    # Associated Users
    text_field(:textfield_associated_user,     :id         =>  "DisplayName_TextBox")
    link(:link_add_dynamic_associated_user,    :xpath      =>  "//div[@class='associate_user_btn_add']/a")
    button(:button_lnk_create_physician,       :id         =>  "lnkCreatePhysician-button")
    button(:button_lnk_clear_create_physician, :id         =>  "lnkClearCreatePhysician-button")

    # Search EP
    div(:div_search_ep, 					             :xpath      => "//form[@id='createPhysician']/div[4]")
    text_field(:textfield_search_by_last_name, :id         =>  "Search")
    button(:button_lnk_search_physician,       :id         =>  "lnkSearchPhysician-button")

    # Search EP list
    div(:div_ep_search_list,                   :id         => "physician_div")
    link(:link_edit,                           :link_text  => "Edit")
    link(:link_delete,                         :link_text  => "Delete")
    link(:link_inactivate,                     :link_text  => "Inactivate")

    # description          : invoked automatically when page class object is created
    # Author               : Gomathi
    #
    def initialize_page
      wait_for_page_load
      # since the EP creation page has changed in Client side
      if @browser.current_url.include? "vm-ehr-aspire-aio"
        wait_for_object(div_physician_element, "Failure in finding EP page container")
      else
        wait_for_object(div_EP_page_element, "Failure in finding create EP page")
      end
      hash_creation
    end

    # Description       : creates hash for indexing table data
    # Author            : Gomathi
    #
    def hash_creation
      @hash_ep_search_list = {
          :TASK => 1,
          :NPI => 2,
          :DISPLAY_NAME => 3,
          :LAST_NAME => 4,
          :FIRST_NAME => 5,
          :SPECIALITY => 6,
          :STATUS => 7
      }
    end

    # description          : Creates a new EP
    # Author               : Gomathi
    # Arguments            :
    #  str_epstage_node    : root node of test data for EP
    #  str_filter          : string that denotes filter
    #  str_value           : string that denotes filter value
    #
    def create_ep(str_filter, str_value, str_epstage_node)
      begin
        # since the EP creation page has changed in Client side
        if @browser.current_url.include? "vm-ehr-aspire-aio"
          click_on(button_new_physician_element)
          wait_for_object(textfield_last_name_element, "Failure in finding Physician last name element")
          #check_check_internal_physician if !check_internal_physician_checked?  # check Internal Physician
          check_internal_physician_element.click if !check_internal_physician_element.checked?  # check Internal Physician
        end

        hash_create_ep = set_scenario_based_datafile(EP_CREATION)

        str_last_name = hash_create_ep[str_epstage_node]["textfield_last_name"]
        str_first_name = hash_create_ep[str_epstage_node]["textfield_first_name"]
        str_status = hash_create_ep[str_epstage_node]["select_status"]

        object_date_time = pacific_time_calculation
        str_last_name = object_date_time.strftime("%d%m%y%H%M%S") # add timestamp to last name field
        self.textfield_last_name = str_last_name
        self.textfield_first_name = str_first_name
        select_status_element.select(str_status)

        if str_filter.downcase == "stage1 start year"
          case str_value.downcase
            when "current year"
              str_stage1_start_year = object_date_time.strftime("%Y")
            when "last year"
              str_stage1_start_year = (object_date_time - 1.years).strftime("%Y")
            when "two years before"
              str_stage1_start_year = (object_date_time - 2.years).strftime("%Y")
            when "three years before"
              str_stage1_start_year = (object_date_time - 3.years).strftime("%Y")
            when "four years before"
              str_stage1_start_year = (object_date_time - 4.years).strftime("%Y")
            else
              raise "invalid value for 'stage1 start year' : #{str_value}"
          end
        else
          raise "invalid input for 'str_filter' : #{str_filter}"
        end
        select_stage1_start_year_element.select(str_stage1_start_year)
        str_NPI = object_date_time.strftime("%d%m%H%M%S")
        self.textfield_NPI = str_NPI

        str_ep_name = "#{textfield_first_name} #{textfield_last_name}"
		    $world.puts("Test data : #{hash_create_ep.to_s}, Test data(change) : textfield_last_name = > #{textfield_last_name}")

        div_search_ep_element.scroll_into_view rescue Exception
        click_on(button_lnk_create_physician_element)

        if is_text_present(self, "Physician created successfully")
          $log.success("EP created successfully and EP name is #{str_ep_name}")
        else
          raise "EP not created"
        end

        if str_epstage_node.downcase == "ep_creation_data_for_stage1"
          $new_stage1_ep_name = str_ep_name
          $new_stage1_ep_first_name = str_first_name
          $new_stage1_ep_last_name = str_last_name
          $new_stage1_ep_npi = str_NPI
        elsif str_epstage_node.downcase == "ep_creation_data_for_stage2"
          $new_stage2_ep_name = str_ep_name
          $new_stage2_ep_first_name = str_first_name
          $new_stage2_ep_last_name = str_last_name
          $new_stage2_ep_npi = str_NPI
        else
          raise "Invalid input for str_epstage_node : #{str_epstage_node}"
        end
        $str_ep_name = str_ep_name
      rescue Exception => ex
        $log.error("Error while creating EP : #{ex}")
        exit
      end
    end

    # description          : Function to Edit eligible Professional
    # Author               : Gomathi
    # Arguments            :
    #   str_ep_stage       : string that denotes stage of EP
    #   str_action         : string that denotes action to be performed on EP
    #
    def edit_ep(str_ep_stage, str_action)
      begin
        if BROWSER.downcase == "chrome"
          div_ep_search_list_element.scroll_into_view rescue Exception
        else
          textfield_search_by_last_name_element.scroll_into_view rescue Exception
        end

        if str_ep_stage.downcase == "stage1 ep"
          self.textfield_search_by_last_name = $new_stage1_ep_last_name
        elsif str_ep_stage.downcase == "stage2 ep"
          self.textfield_search_by_last_name = $new_stage2_ep_last_name
        else
          raise "Invalid stage doctor : #{str_ep_stage}"
        end
        button_lnk_search_physician_element.click
        sleep 1
        if BROWSER.downcase == "chrome"
          div_copy_right_element.scroll_into_view rescue Exception
        else
          div_ep_search_list_element.scroll_into_view rescue Exception
        end

        bool_ep_record = is_record_exists(div_ep_search_list_element, @hash_ep_search_list[:LAST_NAME], textfield_search_by_last_name)
        raise "No EP exists with Last name '#{textfield_search_by_last_name}'" unless bool_ep_record

        iterate = true
        while(iterate)
          div_ep_search_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
            row.scroll_into_view rescue Exception
            if row.cell_element(:xpath => "./td[#{@hash_ep_search_list[:LAST_NAME]}]").text.downcase.strip == textfield_search_by_last_name.downcase
              row.cell_element(:xpath => "./td[#{@hash_ep_search_list[:TASK]}]").image_element(:xpath => "./div/img").focus
              row.cell_element(:xpath => "./td[#{@hash_ep_search_list[:TASK]}]").image_element(:xpath => "./div/img").fire_event("onmouseover")
              case str_action.downcase
                when "inactivated"
                  click_on(link_inactivate_element)
                  raise "Physician not inactivated successfully" unless is_text_present(self, "Physician inactivated successfully", 20)
                  $bool_ep_inactivated = true
                  iterate = false
                  break
                when "deleted"
                  confirm(true) do      # clicks 'Ok' button on the confirm message box
                    link_delete_element.when_visible.click
                  end
                  raise "Physician not deleted successfully" unless is_text_present(self, "Physician deleted successfully", 20)
                  iterate = false
                  break
                else
                  raise "Invalid action for ep : #{str_action}"
              end
            end
          end
          iterate = click_next(div_ep_search_list_element) if iterate
        end
        $log.success("Eligible Professional edited to #{str_action} status successfully")
      rescue Exception => ex
        $log.error("Error while editing EP to #{str_action} status : #{ex}")
        exit
      end

    end


  end
end