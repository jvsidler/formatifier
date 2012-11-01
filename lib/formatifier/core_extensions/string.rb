module Formatifier::CoreExtensions::String
  def formatify(example, strip_current_delimiters=false)
    total_chars = example.size
    delimiters = []

    example.match(/(\W|\s)/).each do |s|
      delimiters << { s.to_s => 0 }
    end

    i = 0
    delimiters.each do |k,v|
      new_i = example.index(k, i)
      self.insert(new_i, k)
      i = new_i
    end

    self
  end
end