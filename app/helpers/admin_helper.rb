module AdminHelper

  # Capitalized item name, with nil check
  def capitalized_name(name)
    result = ''
    if name
      result = name.slice(0,1).capitalize + name.slice(1..-1)
    end
    return result
  end

end
