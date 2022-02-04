module Validate
  def valid?
    begin
      validate!
    rescue StandardError
      return false
    end
    true
  end
end
