class String
  def is_number?
    true if Float(self) rescue false
  end
  def format_number
    Float(self)
    i, f = self.to_i, self.to_f
    i == f ? i : f
    rescue ArgumentError
      self
  end
end
