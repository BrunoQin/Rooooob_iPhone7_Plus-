require "rubygems"
require "bundler"
require "watir"
require "minitest"
require "minitest/autorun"
require "selenium-webdriver"
require "watir-webdriver"
require 'watir-webdriver-performance'
require "rbconfig"
require "minitest/reporters"
require "minitest/unit"
require "fileutils"
require 'byebug'
require 'bacon'
require 'fileutils'
require "watir-webdriver/wait"
require 'httparty'

class WatirConfig

  def self.setup
    @@browser_type = "chrome"
    @@url = "https://reserve.cdn-apple.com/CN/zh_CN/reserve/iPhone/availability?channel=1"
    @@browser_resource = WatirConfig::BrowserResource.new(@@browser_type)
  end

  def self.shutdown_browser
    @@browser_resource.close
  end

  def self.startup_browser
    @@browser_resource.open
  end

  def browser
    @@browser_resource.b
  end

  def url
    @@url
  end

  class BrowserResource
    attr_reader :b
    def initialize(browser_type)
      @browser_type = browser_type
      @started = false
      @b = nil
    end
    def started?
      @started
    end
    def open
      return if started?
      @b = case @browser_type
             when "firefox"
               profile = ::Selenium::WebDriver::Firefox::Profile.new
               profile['network.proxy.type'] = 2
               profile['network.proxy.autoconfig_url'] = "http://proxy.wdf.sap.corp:8080/"
               #profile['network.proxy.ssl'] = "http://proxy.wdf.sap.corp:8080"
               ::Watir::Browser.new :firefox, :profile => profile

             when "ie"
               ::Watir::Browser.new :ie

             when "chrome"
               # ::ChromeDriverProcess.start
               # ::Watir::Browser.new :remote, url: ::ChromeDriverProcess.remote_url
               Watir::Browser.new :chrome#, :switches => %w[--proxy-server=proxy.wdf.sap.corp:8080 --disable-popup-blocking --ignore-certificate-errors --proxy-bypass-list=nikelocal,.sap.corp,electronics.local]
             else
               raise "Invalid browser type #{@browser_type}! Exit!"
           end
      @started = true
    end
    def close
      case @browser_type
        when "firefox"
          @b.close
        when "ie"
          @b.close
        when "chrome"
          @b.quit
      end
      @started = false
    ensure
      ::ChromeDriverProcess.exit if @browser_type == "chrome"
    end
  end

  setup

end
