class ResultMap
  def initialize(store = {})
    @store = store
  end

  def add_entry(entry)
    if @store.has_key?(entry.destination_vertex)
      raise "Cannot add entry for same vertex twice!"
    end

    new_store = @store.dup
    new_store[entry.destination_vertex] = entry
    return ResultMap.new(new_store)
  end

  def has_vertex?(vertex)
    @store.has_key?(vertex)
  end
end
