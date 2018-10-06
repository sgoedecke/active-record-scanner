class Compactor 

  # This is really bad. It works for now but I'd really like to figure out a better way.
  def deep_compact(n)
    10.times do
      n = deep_compact_with_nesting(strip_nesting(n))
    end
    n
  end

  private
  
  def deep_compact_with_nesting(n)
    if n.respond_to? :compact
      n.compact.map{ |c| deep_compact_with_nesting(c) }
    else
      n
    end
  end

  def strip_nesting(n)
    if n.is_a?(Array)
      if n.length == 0
        return nil
      elsif n.length == 1
        return strip_nesting(n.first)
      else
        return n.map{ |n| strip_nesting(n) }
      end
    else
      return n
    end
  end
end
