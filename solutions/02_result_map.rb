class ResultMap
  def initialize(store = {})
    @store = store
  end

  # Store a result entry permanently in the result map. Create a new
  # store and new ResultMap and don't mutate this one.
  def add_entry(entry)
    if @store.has_key?(entry.destination_vertex)
      raise "Cannot add entry for same vertex twice!"
    end

    new_store = @store.dup
    new_store[entry.destination_vertex] = entry
    return ResultMap.new(new_store)
  end

  # Checks if we already have a solution for this vertex.
  def has_vertex?(vertex)
    @store.has_key?(vertex)
  end

  def ==(other_rm)
    store == other_rm.store
  end

  def to_hash
    hash = {}
    @store.each do |v, entry|
      hash[v.name] = entry.to_hash
    end

    hash
  end

  protected
  attr_reader :store
end
