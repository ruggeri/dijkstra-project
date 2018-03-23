class Fringe
  def initialize(store = {})
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
  end

  # Return the lowest cost, best entry in the fringe. Return a hash of
  # { best_entry, fringe }. Again, create a new store with a new
  # Fringe and don't mutate this one.
  def extract
  end

  def empty?
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
