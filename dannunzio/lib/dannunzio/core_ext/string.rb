class String

  # If the string isn't already terminated for sending as a pop3 message, then
  # return a copy of the string, properly terminated. Otherwise, return self.
  def pop_terminate
    return self + "\r\n" unless end_with?("\r\n")
    self
  end

end
