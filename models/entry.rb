class Entry
  attr_accessor :tea_name, :type, :brewing_method

  def initialize(tea_name, type, brewing_method)
    @tea_name = tea_name
    @type = type
    @brewing_method = brewing_method
  end

  def to_s
    "Tea Name: #{tea_name}\nType: #{type}\nBrewing Method: #{brewing_method}"
  end
end
