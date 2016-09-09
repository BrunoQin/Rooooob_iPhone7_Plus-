require_relative '../../lib/base'

class Apple < Base

  def initialize config
    super config
  end

  select_store                  { select_list(:id => "selectStore") }
  select_type                   { select_list(:id => "selectSubfamily") }
  prefer_type                   { div(:id => "128GB").parent }
  light_black                   { uls(:class => "form-selector form-selector-rowwithgutters")[1].lis[4] }

  def select_store_named name
    @browser.wait_until {select_store.present?}
    if select_store.option(:text => name).disabled?
      return false
    end
    select_store.when_present.select name
    return true
  end

  def select_type_named_plus
    @browser.wait_until {select_type.present?}
    if select_type.option(:text => /Plus/).disabled?
      return false
    end
    select_type.when_present.select /Plus/
    return true
  end

  def select_prefer_type
    @browser.wait_until {prefer_type.present?}
    if prefer_type.attribute_value("class").include? "unavailable"
      return false
    end
    prefer_type.click
    return true
  end

  def select_light_black
    @browser.wait_until {light_black.present?}
    if light_black.div.attribute_value("id").include? "unavailable"
      return false
    end
    light_black.click
    return true
  end

end
