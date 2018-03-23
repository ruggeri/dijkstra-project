class ResultMap
  def initialize(store = {})
  end

  # Store a result entry permanently in the result map. Create a new
  # store and new ResultMap and don't mutate this one.
  def add_entry(entry)
  end

  # Checks if we already have a solution for this vertex.
  def has_vertex?(vertex)
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
