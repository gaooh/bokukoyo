module IcalHelper
  
  def break_set(value)
    value.gsub(/\n/, '\\n ')
  end
  
end
