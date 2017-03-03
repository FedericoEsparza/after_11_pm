include ClassName

module Types
  def numerical?(object)
    object.is_a?(integer) || object.is_a?(float) || object.is_a?(fraction)
  end

  def elementary?(object)
    numerical?(object) || object.is_a?(string)
  end
end
