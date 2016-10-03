=begin
  *Name             : DesktopMaster
  *Description      : class that holds the desktop web Master page objects and method definitions
  *Author           : Chandra sekaran
  *Creation Date    : 05/03/2015
  *Modification Date:
=end

module EHR
  class DesktopMaster < MasterPage

    # Description      : function for checking if desktop web MU checklist data is compliant
    # Author           : Chandra sekaran
    # Argument         :
    #   str_section    : MU checklist ribbon name
    # Return argument  :
    #   bool_return    : a boolean value
    #
    def is_mu_checklist_compliant(str_section)
      begin
        bool_return = case str_section.downcase
                        when /allerg/
                          link_allergies_ribbon_element.text.strip.downcase.include? "today"
                        when /medication/
                          link_medications_ribbon_element.text.strip.downcase.include? "today"
                        when /problem/
                          link_problems_ribbon_element.text.strip.downcase.include? "today"
                        when /vital/
                          #link_vitals_ribbon_element.text.strip.downcase.include? "today"
                          (link_vitals_ribbon_element.text.strip.downcase.include?("today"))||(link_vitals_ribbon_element.text.strip.downcase.include?("1 day ago"))||(link_vitals_ribbon_element.text.strip.downcase.include?("exempt"))
                        else
                          raise "Invalid MU checklist section name : #{str_section}"
                      end
      rescue Exception => ex
        $log.error("Failure in finding compliance for #{str_section} MU checklist ribbon : #{ex}")
        exit
      end
    end

  end
end