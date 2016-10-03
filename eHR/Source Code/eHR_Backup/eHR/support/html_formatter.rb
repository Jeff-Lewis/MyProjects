=begin
*Name           : HtmlFormatter
*Description    : class that defines wrapper methods for Cucumber generated report
*Author         : Chandra sekaran
*Creation Date  : 09/12/2014
*Updation Date  :
=end

require 'cucumber/formatter/html'

module Formatter
  class HtmlFormatter < Cucumber::Formatter::Html    # for uaing @builder object
    
    # Description      : embeds the given input file type to cucumber report
    # Author           : Chandra sekaran
    # Argument         :
    #  str_src         : relative path of the file
    #  str_mime_type   : type of file
    #  str_label       : link text on click of click of which shows the embedded file
    #
    def embed(str_src, str_mime_type, str_label)
      case str_mime_type
        when /^image\/(png|gif|jpg|jpeg)/
          embed_image(str_src, str_label)
        when /^text\/plain/
          embed_file(str_src, str_label)
      end
    end

    # Description      : embeds a link with the given input string
    # Author           : Chandra sekaran
    # Argument         :
    #  str_src         : relative path of the file
    #  str_label       : link text
    #
    def embed_link(str_src, str_label)
      @builder.span(:class => 'embed') do |pre|
        pre << %{<a href="#{str_src}" target="_blank">"#{str_label}"</a> }
      end
    end

    # Description      : embeds the given input file type to cucumber report
    # Author           : Chandra sekaran
    # Argument         :
    #  str_src         : relative path of the file
    #  str_label       : link text on click of click of which shows the embedded file
    #
    def embed_file(str_src, str_label = "Click to view embedded file")
        id = "object_#{Time.now.strftime("%y%m%d%H%M%S")}"
        @builder.span(:class => 'embed') do |pre|
          pre << %{<a href="" onclick="o=document.getElementById('#{id}'); o.style.display = (o.style.display == 'none' ? 'block' : 'none');return false">#{str_label}</a><br>&nbsp;
	        <object id="#{id}" data="#{str_src}" type="text/plain" width="100%" style="height: 10em;display: none"></object>}
        end
    end

  end
end