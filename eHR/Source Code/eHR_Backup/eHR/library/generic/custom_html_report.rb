=begin
*Name           : CustomHtmlReport
*Description    : class that holds custom report file generator methods
*Author         : Chandra sekaran
*Creation Date  : 11/11/2014
*Updation Date  : 19/02/2015
=end

module EHR
  class CustomHtmlReport
    include FileLibrary
    include DateTimeLibrary

    # Description       : invoked automatically when an object of the class type is created
    # Author            : Chandra sekaran
    # Arguments         :
    #   arr_file_paths  : array of html report file paths
    #
    def initialize(arr_file_paths)
      @arr_file_name = arr_file_paths
      @template_file_name = arr_file_paths.first   # take the html template from first html file

      @scenario=[]
      @scenario_pass=[]
      @scenario_fail=[]
      @scenario_skip=[]
      @scenario_pending=[]
      @scenario_undefined=[]
      @step=[]
      @step_pass=[]
      @step_fail=[]
      @step_skip=[]
      @step_pending=[]
      @step_undefined=[]

      @feature=[]
      @arr_html_file_name = []
      @arr_testcase_id = []
    end

    # Description       : creates new directory for custom report files and copies other dependents
    # Author            : Chandra sekaran
    #
    def create_report_directory
      begin
        create_directory("#{$current_log_dir}/custom_report")
        create_directory("#{$current_log_dir}/custom_report/detailed_report")
        FileUtils.cp("library/generic/app_logo_1.png", "#{$current_log_dir}/custom_report/detailed_report")
        # copy screenshot directory to custom_report directory for image attachment of custom report html files
        FileUtils.cp_r("#{$current_log_dir}/screenshot", "#{$current_log_dir}/custom_report/detailed_report") rescue Exception
      rescue Exception => ex
        $log.error("Error in creating custom report directory : #{ex}")
        exit
      end
    end

    # Description       : creates new html template object based cucumber report file generated
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_file_path   : file path of html file
    # Return arguments  :
    #   html_template   : html object
    #
    def create_html_template(str_file_path)
      begin
        html_template = Nokogiri::HTML(File.read(str_file_path))
        html_template.xpath("//div[@id='label']/h1").each do |t|
          t.replace("<h1>eHR - TEST REPORT SUMMARY</h1>")
        end

        bottom = Nokogiri::XML::Node.new("footer", html_template)
        div = html_template.at_css("div.feature")
        div.add_next_sibling(bottom)

        html_template.at('footer')["id"] = "footer"

        html_template.xpath("//div[@class='feature']").each do |n|
          n.replace(Nokogiri::XML::Node.new("p", html_template))
        end

        footer = Nokogiri::XML::Node.new("div", html_template)
        timestamp = Nokogiri::XML::Node.new("div", html_template)
        timestamp.inner_html = "<font color='white' size='2'>Executed on #{Time.now.strftime('%m-%d-%Y %I:%M:%S')} <br> Executed in #{ENV['COMPUTERNAME']} (#{ENV['OS']}) / #{BROWSER.capitalize} (#{$browser_version})</font>"
        logo = Nokogiri::XML::Node.new("img", html_template)

        footer.add_child(logo)
        footer.add_child(timestamp)

        footer['style'] = "background-color: #363636;"  # black color

        footer.add_child("<style type='text/css'>#footer {position : fixed;margin-top : 35px;text-align:center;width: 100%;height: 63px;bottom: 0px; left: 0px;}</style>")
        bottom.add_child(footer)
        html_template.at('img')["src"] = "detailed_report/app_logo_1.png"
        html_template.at('img')["height"] = "30px"

        html_template.xpath("//div[@id='summary']/p[1]").each do |t|
          t.replace(Nokogiri::XML::Node.new("p", html_template))     # remove pass/fail count in the report header
        end

        return html_template
      rescue Exception => ex
        $log.error("Error in creating report html template : #{ex}")
        exit
      end
    end

    # Description       : creates new html file holding complete execution summary
    # Author            : Chandra sekaran
    #
    def create_main_report
      begin
        @html_template = create_html_template(@template_file_name)
        template_header  = @html_template.at_css "div#cucumber-header"
        timestamp = Nokogiri::XML::Node.new("h4", @html_template)
        timestamp.inner_html = "Executed on #{$log_env.get_formatted_datetime($start_time)}"
        logo = Nokogiri::XML::Node.new("img", @html_template)
        h1 = @html_template.at_css "h1"

        br = Nokogiri::XML::Node.new("div", @html_template)
        br.inner_html="<br><br><br>"

        @table = Nokogiri::XML::Node.new("table", @html_template)

        row_size = @feature.size

        create_report_table_header

        @tot_feature = 0
        @tot_scenario = 0
        @tot_scenario_pass = 0
        @tot_scenario_fail = 0
        @tot_scenario_skip = 0
        @tot_scenario_pending = 0
        @tot_scenario_undefined = 0
        @tot_step = 0
        @tot_step_pass = 0
        @tot_step_fail = 0
        @tot_step_skip = 0
        @tot_step_pending = 0
        @tot_step_undefined = 0

        for i in 1..row_size
          tr = Nokogiri::XML::Node.new("tr", @html_template)

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{i}"
          tr.add_child(td)
          @tot_feature = i

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = @arr_testcase_id[i-1].join(", ").to_s
          tr.add_child(td)

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "<a href='detailed_report/#{@arr_html_file_name[i-1]}.html' target='_blank'>#{@feature[i-1]}</a>"
          tr.add_child(td)
          td['width'] = "40%"

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@scenario[i-1]}"
          tr.add_child(td)
          @tot_scenario += @scenario[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          num_pass_count = @scenario_pass[i-1]
          td.inner_html = "#{num_pass_count}"
          td['style'] = "background-color: #b0f9c3;" if num_pass_count > 0   # green color
          tr.add_child(td)
          @tot_scenario_pass += num_pass_count

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@scenario_fail[i-1]}"
          td['style'] = "background-color: #fbc8d5;" if @scenario_fail[i-1] > 0   # red color
          tr.add_child(td)
          @tot_scenario_fail += @scenario_fail[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@scenario_skip[i-1]}"
          td['style'] = "background-color: #f2f9b0;" if @scenario_skip[i-1] > 0   # yellow color
          tr.add_child(td)
          @tot_scenario_skip += @scenario_skip[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@scenario_pending[i-1]}"
          td['style'] = "background-color: #f2f9b0;" if @scenario_pending[i-1] > 0   # yellow color
          tr.add_child(td)
          @tot_scenario_pending += @scenario_pending[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@scenario_undefined[i-1]}"
          td['style'] = "background-color: #f2f9b0;" if @scenario_undefined[i-1] > 0   # yellow color
          tr.add_child(td)
          @tot_scenario_undefined += @scenario_undefined[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@step[i-1]}"
          tr.add_child(td)
          @tot_step += @step[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@step_pass[i-1]}"
          td['style'] = "background-color: #b0f9c3;" if @step_pass[i-1] > 0   # green color
          tr.add_child(td)
          @tot_step_pass += @step_pass[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@step_fail[i-1]}"
          td['style'] = "background-color: #fbc8d5;" if @step_fail[i-1] > 0   # red color
          tr.add_child(td)
          @tot_step_fail += @step_fail[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@step_skip[i-1]}"
          td['style'] = "background-color: #f2f9b0;" if @step_skip[i-1] > 0   # yellow color
          tr.add_child(td)
          @tot_step_skip += @step_skip[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@step_pending[i-1]}"
          td['style'] = "background-color: #f2f9b0;" if @step_pending[i-1] > 0   # yellow color
          tr.add_child(td)
          @tot_step_pending += @step_pending[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = "#{@step_undefined[i-1]}"
          td['style'] = "background-color: #f2f9b0;" if @step_undefined[i-1] > 0    # yellow color
          tr.add_child(td)
          @tot_step_undefined += @step_undefined[i-1]

          td = Nokogiri::XML::Node.new("td", @html_template)
          td.inner_html = @scenario_fail[i-1] > 0 ? "Failed" : "Passed"
          td['style'] = @scenario_fail[i-1] > 0 ? "background-color: #fbc8d5;" : "background-color: #b0f9c3;"
          tr.add_child(td)

          @table.add_child(tr)
        end

        create_report_table_footer

        @table['style'] = "width:90%; font:13px;"
        10.times { template_header.add_next_sibling("<br>") }
        template_header.add_next_sibling(@table)
        3.times { template_header.add_next_sibling("<br>") }
        template_header.add_child("<style type='text/css'>td, th {color: black; font: normal 11.5px 'Lucida Grande', Helvetica, sans-serif;}</script>")
        @html_template.at('table')["border"] = 2
        @html_template.at('table')["align"] = "center"

        # set report header background color
        if @tot_scenario_fail > 0    # for red color header
          template_header.add_child("<script type='text/javascript'> $('#cucumber-header').css('background', '#c40d0d'); $('#cucumber-header').css('color', '#FFFFFF');</script>")
        elsif @tot_scenario_pending > 0  # for yellow color header
          template_header.add_child("<script type='text/javascript'> $('#cucumber-header').css('background', '#f2f9b0'); $('#cucumber-header').css('color', '#000000');</script>")
        else  # for green color header
          template_header.add_child("<script type='text/javascript'> $('#cucumber-header').css('background', '#65c400'); $('#cucumber-header').css('color', '#FFFFFF');</script>")
        end

        # replace the existing pass/fail counts by the actual count in the report header
        str_total = ""
        str_total << "<p style='font-size:1.2em' id='custom_total'>#{@tot_scenario} scenarios (#{@tot_scenario_fail} failed, #{@tot_scenario_skip} skipped, #{@tot_scenario_pending} pending, #{@tot_scenario_pass} passed) <br>"
        str_total << "#{@tot_step} steps (#{@tot_step_fail} failed, #{@tot_step_skip} skipped, #{@tot_step_pending} pending, #{@tot_step_pass} passed)</p>"
        @html_template.xpath("//div[@id='summary']/p[1]").each do |t|
          t.replace(str_total)
        end

        File.open("#{$current_log_dir}/custom_report/report_home.html", "w") do |f|
          f.write(@html_template)
        end
      rescue Exception => ex
        $log.error("Error in creating main html report : #{ex}")
        exit
      end
    end

    # Description       : creates new html files holding complete execution summary for each feature
    # Author            : Chandra sekaran
    # Argument          :
    #   str_file_path   : file path of the report file
    #
    def create_sub_report(str_file_path)
      begin
        @html_doc = Nokogiri::HTML(File.read(str_file_path))
        br = Nokogiri::XML::Node.new("p", @html_doc)

        @html_doc.xpath("//div[@class='feature']").each_with_index do |f, index|
          @html_template1 = create_html_template(@template_file_name)
          @html_template1.at('img')["src"] = "app_logo_1.png"  # change the image file path for the sub-report files
          template_header1  = @html_template1.at_css "div#cucumber-header"

          @feature << f.xpath("./h2/span[@class='val']").text.gsub("Feature:", "")

          begin     # for feature documentation header content
            pre_old  = f.at_css "pre"
            f.xpath("./pre").each do |t|
              t.replace("<br><br><br><br><br><pre><font color='black'>")
            end
            font  = f.at_css "font"
            font.add_child(pre_old)
          rescue Exception => ex
          end

          template_header1.add_child(f)
          6.times { template_header1.add_child("<br>") }
          h2  = @html_template1.at_css "h2"
          h2["style"] = "color: black;"

          failed_step = @html_template1.at_css("//li[@class='step failed']")
          if !failed_step.nil?
            template_header1.add_child("<script type='text/javascript'> $('#cucumber-header').css('background', '#C40D0D'); $('#cucumber-header').css('color', '#FFFFFF');</script>")
          end

          @scenario_skip_count = 0

          cstep = 0
          cstep_pass = 0
          cstep_fail = 0
          cstep_skip = 0
          cstep_pending = 0
          cstep_undefined = 0

          bstep = 0
          bstep_pass = 0
          bstep_fail = 0
          bstep_skip = 0
          bstep_pending = 0

          f.search("./div[@class='background']").each do |s|
            bstep = s.search(".//ol/li/div[@class='step_name']").size
            bstep_pass = s.search(".//ol/li[@class='step passed']").size
            bstep_fail = s.search(".//ol/li[@class='step failed']").size
            bstep_skip = s.search(".//ol/li[@class='step skipped']").size
            bstep_pending = s.search(".//ol/li[@class='step pending']").size
          end

          @scenario << f.search("./div[@class='scenario']").size
          tmp = []
          break_count = true   # for getting scenario ID of scenario that has failed in Background itself
          @pass_step_count = 0
          @fail_step_count = 0
          if bstep_fail > 0
            f.search("./div[@class='scenario']").each_with_index do |s, indx|
              cstep += bstep
              cstep_fail = bstep_fail
              cstep_skip += bstep_skip
              cstep_pending += bstep_pending

              cstep += s.search(".//ol/li/div[@class='step_name']").size
              cstep_skip += s.search(".//ol/li[@class='step skipped']").size
              cstep_pending += s.search(".//ol/li[@class='step pending']").size

              if s.search(".//ol/li/div[@class='step_name']").size == s.search(".//ol/li[@class='step skipped']").size
                @scenario_skip_count += 1
              elsif (s.search(".//ol/li/div[@class='step_name']").size - s.search(".//ol/li[@class='step skipped']").size) > 0
                @scenario_skip_count += 1
              end

              # setting colors for the scenario IDs under the feature
              s.search("./span[@class='tag'][1]").each do |tag|
                if cstep_fail >= 1 && break_count
                  tmp << "<span style='color:red'>#{tag.inner_text.strip.gsub("@tc_","")}</span>"
                  break_count = false
                  @fail_step_count += 1
                elsif s.search(".//ol/li[@class='step skipped']").size >= 1
                  tmp << "<span style='color:#B0A914'>#{tag.inner_text.strip.gsub("@tc_","")}</span>"
                else
                  tmp << "<span style='color:green'>#{tag.inner_text.strip.gsub("@tc_","")}</span>"
                end
              end
            end
            scenario_undefined_count = 0
          else
            scenario_undefined_count = 0
            f.search("./div[@class='scenario']").each_with_index do |s, indx|
              cstep += bstep
              cstep_pass += bstep_pass
              cstep_fail += bstep_fail
              cstep_skip += bstep_skip
              cstep_pending += bstep_pending

              cstep += s.search(".//ol/li/div[@class='step_name']").size
              cstep_pass += s.search(".//ol/li[@class='step passed']").size
              cstep_fail += s.search(".//ol/li[@class='step failed']").size
              cstep_skip += s.search(".//ol/li[@class='step skipped']").size
              cstep_pending += s.search(".//ol/li[@class='step pending']").size
              cstep_undefined += s.search(".//ol/li[@class='step undefined']").size

              # setting colors for the scenario IDs under the feature
              s.search("./span[@class='tag'][1]").each do |tag|
                if s.search(".//ol/li[@class='step failed']").size >= 1
                  tmp << "<span style='color:red'>#{tag.inner_text.strip.gsub("@tc_","")}</span>"
                  @fail_step_count += 1
                elsif s.search(".//ol/li[@class='step skipped']").size >= 1
                  tmp << "<span style='color:#B0A914'>#{tag.inner_text.strip.gsub("@tc_","")}</span>"
                else
                  tmp << "<span style='color:green'>#{tag.inner_text.strip.gsub("@tc_","")}</span>"
                end
              end
              if s.search(".//ol/li[@class='step undefined']").size > 0
                scenario_undefined_count += 1 if s.search(".//ol/li[@class='step failed']").size == 0
              end
              if s.search(".//ol/li/div[@class='step_name']").size == s.search(".//ol/li[@class='step passed']").size
                @pass_step_count += 1
              end
            end
          end

          @scenario_pass << @pass_step_count
          @scenario_fail << @fail_step_count

          @step << cstep
          @step_pass << cstep_pass
          @step_fail << cstep_fail
          #if @step_pass[index] <= 0            # not required
          #  @step_skip << @scenario[index]+cstep_skip
          #else
          #  @step_skip << cstep_skip
          #end
          @step_skip << cstep_skip
          @step_pending << cstep_pending

          #if @step_fail[index] > 0           # not required; logic changed and moved up
          #  @scenario_fail << @step_fail[index]
          #else
          #  @scenario_fail << 0
          #end

          if @scenario_skip_count - 1 < 0
            @scenario_skip << 0
          else
            @scenario_skip << @scenario_skip_count - 1
          end
          @scenario_pending << cstep_pending
          @step_undefined << cstep_undefined
          @scenario_undefined << scenario_undefined_count

          @arr_testcase_id << tmp

          feature_name = f.xpath("./div[@class='scenario']/span[@class='scenario_file']").inner_text.strip
          arr_feature_file_path = format_file_path(feature_name).split("/")
          str_feature_name = arr_feature_file_path.pop.split(".").first
          arr_feature_folder_name = arr_feature_file_path.pop(2)
          html_file_name = "#{arr_feature_folder_name[0]}_#{str_feature_name}"   # add stage name with fetaure file name
          @arr_html_file_name << html_file_name

          File.open("#{$current_log_dir}/custom_report/detailed_report/#{html_file_name}.html", "w") do |file|
            file.write(@html_template1)
          end
        end
        @html_doc.xpath("//div[@class='feature']/div[@class='scenario']").each do |n|
          n.replace(br)
        end
      rescue Exception => ex
        $log.error("Error in creating sub report html : #{ex}")
        exit
      end
    end

    # Description       : creates header for report table
    # Author            : Chandra sekaran
    #
    def create_report_table_header
      begin
        arr_table_header = ["Sr No","Scenario ID","Feature","Total","Passed","Failed","Skipped","Pending","Undefined","Total","Passed","Failed","Skipped","Pending","Undefined","Result"]

        tr = Nokogiri::XML::Node.new("tr", @html_template)
        5.times do |col|
          td = Nokogiri::XML::Node.new("td", @html_template)
          case col
            when 1
              td["colspan"] = "2"
            when 2
              td["colspan"] = "6"
              td.inner_html = "<b>Scenarios</b>"
              td['align'] = "center"
            when 3
              td["colspan"] = "6"
              td.inner_html = "<b>Steps</b>"
              td['align'] = "center"
          end
          td['style'] = "background-color: #d3ecfc;"
          tr.add_child(td)
        end
        @table.add_child(tr)

        tr = Nokogiri::XML::Node.new("tr", @html_template)
        arr_table_header.each do |str_header|
          th = Nokogiri::XML::Node.new("th", @html_template)
          th.inner_html = "<b>#{str_header}</b>"
          th['style'] = "background-color: #d3ecfc;"   # light blue color
          th["font"] = "size: 15px;"
          tr.add_child(th)
        end
        @table.add_child(tr)
      rescue Exception => ex
        $log.error("Error while creating report table header : #{ex}")
        exit
      end
    end

    # Description       : creates footer for report table
    # Author            : Chandra sekaran
    #
    def create_report_table_footer
      begin
        tr = Nokogiri::XML::Node.new("tr", @html_template)
        16.times do |col|
          td = Nokogiri::XML::Node.new("td", @html_template)
          case col
            when 2
              td.inner_html = "<b>Total<b>"
              td["align"] = "right"
            when 3
              td.inner_html = "<b>#{@tot_scenario.to_s}</b>"
            when 4
              td.inner_html = "<b>#{@tot_scenario_pass.to_s}</b>"
            when 5
              td.inner_html = "<b>#{@tot_scenario_fail.to_s}</b>"
            when 6
              td.inner_html = "<b>#{@tot_scenario_skip.to_s}</b>"
            when 7
              td.inner_html = "<b>#{@tot_scenario_pending.to_s}</b>"
            when 8
              td.inner_html = "<b>#{@tot_scenario_undefined.to_s}</b>"
            when 9
              td.inner_html = "<b>#{@tot_step.to_s}</b>"
            when 10
              td.inner_html = "<b>#{@tot_step_pass.to_s}<b>"
            when 11
              td.inner_html = "<b>#{@tot_step_fail.to_s}</b>"
            when 12
              td.inner_html = "<b>#{@tot_step_skip.to_s}</b>"
            when 13
              td.inner_html = "<b>#{@tot_step_pending.to_s}</b>"
            when 14
              td.inner_html = "<b>#{@tot_step_undefined.to_s}</b>"
          end
          td['style'] = "background-color: #d3ecfc;"
          tr.add_child(td)
        end

        @table.add_child(tr)
      rescue Exception => ex
        $log.error("Error while creating report table footer : #{ex}")
        exit
      end
    end

    # Description       : creates new custome html report files
    # Author            : Chandra sekaran
    #
    def create_custom_report
      begin
        create_report_directory
        @arr_file_name.each do |path|     # move screenshot directory
          path = format_file_path(path)
          arr = path.split("/")
          arr.pop                 # remove the html file name
          path = arr.join("/")
          Dir.glob(path).each do |file|
            if File.directory?("#{file}/screenshot")     # check if screenshot directory exists else create a new one and copy it to the recent log directory
              create_directory("#{$current_log_dir}/custom_report/detailed_report/screenshot")
              FileUtils.cp Dir["#{File.expand_path(file)}/screenshot/*.png"], "#{$current_log_dir}/custom_report/detailed_report/screenshot"
            end
          end
        end
        @arr_file_name.each do |path|     # create sub report
          create_sub_report(path)
        end
        create_main_report       # create consolidated home report file
        $log.success("Custom html report file has been generated successfully")
      rescue Exception => ex
        $log.error("Error in creating custom html report : #{ex}")
        exit
      end
    end

  end
end