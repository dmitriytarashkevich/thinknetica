module Validate

  def valid?
    validate! rescue return false
    true
  end

end
