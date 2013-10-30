class Hash

  def slice(*keep_keys)
    hash = {}
    keep_keys.each do |key|
      hash[key] = fetch(key) if key?(key)
    end
    hash
  end

end
