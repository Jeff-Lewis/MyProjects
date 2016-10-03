=begin
*Name           : env.rb
*Description    : requires the important classes/modules for application execution
*Author         : Chandra sekaran
*Creation Date  : 23/08/2014
*Updation Date  :
=end

# for creating code coverage report
if !ENV["CODE_COVERAGE"].nil? && (["yes", "true"].include?(ENV["CODE_COVERAGE"].downcase))
  require "simplecov"
  require "simplecov-json"
  require "simplecov-rcov"
  SimpleCov.formatters = [
      SimpleCov::Formatter::RcovFormatter
  ]
  #SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::JSONFormatter
  SimpleCov.start
end

require "rubygems"
require "page-object"
require "watir-webdriver"
#require "selenium-webdriver"
require "yaml"
require "logger"
require "fileutils"
require "time_difference"
require "data_magic"
require "spreadsheet"
require "require_all"
require "win32/clipboard"
require "nokogiri"
require "open3"    # for capturing STDOUT, STDERR messages
require "json"     # for json file manipulation in performance report
if ENV["PLATFORM"].downcase == "desktop"
  require "dbi"      # for db Sybase - performance report data store
end
require "appium_lib"
require "pdf-reader"

require_all "library"
require_all "object_repository"

World(PageObject::PageFactory)

# environment variables moved to constants that is visible thought the application
PLATFORM = ENV["PLATFORM"] || nil     # for platform if desktop/mobile
BROWSER = ENV["BROWSER"] || nil       # for browser if firefox/chrome/internet_explorer/safari/android
BOX = ENV["BOX"] || nil               # for box name having multiple profiles
DEVICE = ENV["DEVICE"] || nil         # for mobile device if it is attached to the machine
RESET_CONFIG_VALUES = ENV["RESET_CONFIG_VALUES"] || nil    # for releasing profiles and other execution parameters

$REPORT_FILE_NAME = "report_#{$$}"    # name of the cucumber generated report file

# validating command environment variables
raise "Command Line Exception : PLATFORM can not be nil" if PLATFORM.nil?
raise "Command Line Exception : BROWSER can not be nil" if BROWSER.nil?

PageObject.javascript_framework = :jquery  # for handling AJAX

World(EHR::PageUtils)  # make PageUtils methods global to entire TAF
World(EHR::MobileMasterPage)  # make MobileMasterPage methods global to entire TAF