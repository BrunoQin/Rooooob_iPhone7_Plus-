require_relative '../lib/watir_config'
require_relative '../lib/page/apple'

class Rab

  attr_accessor :store_name, :iphone_type
  attr_accessor :apple_page
  attr_accessor :status
  attr_accessor :browser

  def initialize
    @config ||= WatirConfig.new
    WatirConfig.startup_browser
    @apple_page = Apple.new(@config)
    @status = true
    @browser = @config.browser
    @browser.goto @config.url

    @store_name = [/上海环贸/, /五角场/, /南京东路/, /浦东/, /香港广场/, /环球港/]
    @iphone_type = /Plus/

  end

end

rab = Rab.new
1000000.times do
  rab.store_name.each do |name|
    rab.status = true
    if rab.status == true
      rab.status = rab.apple_page.select_store_named name
    else
      rab.browser.refresh
      next
    end
    if rab.status == true
      rab.status = rab.apple_page.select_type_named_plus
    else
      rab.browser.refresh
      next
    end
    if rab.status == true
      rab.status = rab.apple_page.select_prefer_type
    else
      rab.browser.refresh
      next
    end
    if rab.status == true
      rab.status = rab.apple_page.select_light_black
    else
      rab.browser.refresh
      next
    end
    if rab.status == true
      byebug
    else
      rab.browser.refresh
    end
  end
end
