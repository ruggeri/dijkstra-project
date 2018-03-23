class Fringe
  def initialize(store = {})
    @store = store
  end

  # Stores a new entry in the fringe if the new entry is superior to
  # the old entry.
  #
  # Return a hash of { action, fringe }. Fringe should be either self
  # (if prior entry was superior) or a new Fringe with a new store. Do
  # not mutate the original fringe.
  #
  # Action should be one of (a) :old_entry_better, (b) :insert (first
  # entry for this vertex, or (c) :update (replaced worse entry).
 def add_entry(entry)
    unless entry.superior_to?(@store[entry.destination_vertex])
      # Return nothing
      return {
        action: :old_entry_better,
        fringe: self,
      }
    end

    if @store[entry.destination_vertex].nil?
      action = :insert
    else
      action = :update
    end

    new_store = @store.dup
    new_store[entry.destination_vertex] = entry
    return {
      action: action,
      fringe: Fringe.new(new_store),
    }
  end

  # Return the lowest cost, best entry in the fringe. Return a hash of
  # { best_entry, fringe }. Again, create a new store with a new
  # Fringe and don't mutate this one.
  def extract
    best_entry = nil
    @store.each do |vertex, entry|
      best_entry = entry if entry.superior_to?(best_entry)
    end

    new_store = @store.dup
    new_store.delete(best_entry.destination_vertex)
    return {
      best_entry: best_entry,
      fringe: Fringe.new(new_store),
    }
  end

  def empty?
    @store.empty?
  end

  def ==(other_fringe)
    store == other_fringe.store
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
