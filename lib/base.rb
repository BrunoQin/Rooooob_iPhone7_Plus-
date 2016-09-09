class Base

  def initialize config
    @c = config
    @browser = config.browser
  end

  def dom_lookups
    @dom_lookups ||= (self.class.const_defined?(:DOM_LOOKUPS) ?  self.class::DOM_LOOKUPS : {})
  end

  def method_missing name, *arg
    if dom_lookups.include? name
      return @browser.instance_eval &dom_lookups[name]
    else
      puts "Unknown element"
      super name, *arg
    end
  end

  def self.method_missing name, &block
    unless self.const_defined?(:DOM_LOOKUPS)
      self.const_set(:DOM_LOOKUPS,{})
    end
    self::DOM_LOOKUPS[name] = block
  end

end
