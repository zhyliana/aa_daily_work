class Hash
  def set_add_el(hash, sym)
    hash[sym]=true
    hash
  end
  def set_remove_el(hash,sym)
    hash.delete(sym)
    hash
  end
  def set_list_els(hash)
    result = []
    hash.keys.each { |k| result << k}
    result
  end
  def member?(hash, sym)
    hash.keys.include?(sym)
  end
  def union(hash1,hash2)
    hash1.merge(hash2)
  end
  def intersection(hash1, hash2)
    results = []
    hash1.keys.map do|k|
      if hash2.keys.include?(k)
        results << k
      end
    end
    results.uniq
  end
  def set_minus(hash1, hash2)
    hash1.keys.map do|k|
      unless hash2.keys.include?(k)
        results << k
      end
    end
    results
  end
  end


end
