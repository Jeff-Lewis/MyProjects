=begin
  *Name             : MasterPage
  *Description      : class that holds common page objects and method definitions
  *Author           : Chandra sekaran
  *Creation Date    : 21/01/2015
  *Modification Date:
=end

module EHR
  module MobileMasterPage
    include PageObject
    include PageUtils

    image(:img_logo,                                :src      => "/Content/themes/base/images/ehr_mu_logo.png")
    button(:button_home,                            :id       => "btnHome")
    link(:link_logout,                              :href     => "/Home/Logout")
    div(:link_next,                                 :xpath    => "//div[@id='divform']/div[2]/div[3]")
    #link(:link_next,                                :id       => "btnNext")
    #span(:link_next,                                :xpath    => "//a[@id='btnNext']/span")
    #span(:link_next,                                :xpath    => "//span[contains(@class, 'ui-icon-myapp-next')]")
    div(:link_previous,                             :xpath    => "//div[@id='divform']/div[2]/div[1]")
    #link(:link_previous,                            :id       => "btnPrevious")
    div(:div_entry_completion_msg,                  :class    => "ui-content")
    link(:link_entry_completion_ok,                 :href     => "/Home/Index")

    span(:span_loading_image,                       :xpath    => "//span[contains(@class,'ui-icon-loading')]")

    # Description          : function that waits untill the loading image in not visible
    # Author               : Chandra sekaran
    #
    def wait_for_image_loading
      wait_until(1) { span_loading_image_element.visible? } rescue Exception
      wait_until(PageObject.default_element_wait, "Timed out after waiting for #{PageObject.default_page_wait}s") { !span_loading_image_element.visible? } rescue Exception
    end

    # Description     : function for clicking an web element
    # Author          : Chandra sekaran
    # Argument        :
    #   element       : web element object
    #
    def touch(element)
      #wait_for_object(element, "Could not find element (#{element})")
      element.scroll_into_view rescue Exception
      element.focus rescue Exception
      begin
        element.click
      rescue Exception => ex
        if (ex.message.include? "unknown error: Element is not clickable at point") || (ex.message.include? "Other element would receive the click")
          $log.error("touch error : #{ex}")
          element.fire_event("click") #rescue Exception
        else
          $log.error("Error in clicking element #{element}: #{ex}")
          raise ex
        end
      end
      wait_for_image_loading
    end

    # Description     : function for clicking Next '>' link - for page navigation
    # Author          : Chandra sekaran
    #
    def click_next
      touch(link_next_element)
      ##@browser.action.drag_and_drop_by(link_next_element, 100, 100).perform
      #"/html/body/div[1]/div[1]/h1/img"
      #obj = @browser.find_element(:xpath, "/html/body/div[1]/div[1]/h1/img")#:src, "/Content/themes/base/images/ehr_mu_logo.png")
      #target1 = @browser.find_element(:href, "/Home/Logout")
      #target2 = @browser.find_element(:id, "btnHome")
      #@browser.action.drag_and_drop(obj, target2).perform

      #h = {:start_x => 60, :start_y => 40, :end_x => 0, :end_y => 40, :duration => 1}
      #Appium::TouchAction.new.swipe(h).perform
    end

    # Description     : function for clicking Previous '<' link - for page navigation
    # Author          : Chandra sekaran
    #
    def click_previous
      touch(link_previous_element)
    end

    # Description     : function for clicking 'Ok' button on last page - after completing all data entry
    # Author          : Chandra sekaran
    #
    def complete_data_entry
      touch(link_entry_completion_ok_element)
    end
  end
end