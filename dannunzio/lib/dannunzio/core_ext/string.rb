class String

  POP_TERMINATE_MULTI = '.'.freeze
  POP_TERMINATE_LINE  = "\r\n".freeze

  # If the string isn't already terminated for sending as a pop3 message, then
  # return a copy of the string, properly terminated. Otherwise, return self.
  def pop_line_terminate
    return self + POP_TERMINATE_LINE unless end_with?(POP_TERMINATE_LINE)
    self
  end

  # If the string starts with the pop3 terminate multi octet, then return a
  # copy of the string with an additional terminate octet prepended.
  def pop_bytestuff
    return POP_TERMINATE_MULTI + self if start_with?(POP_TERMINATE_MULTI)
    self
  end

end
