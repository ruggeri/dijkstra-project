class Fringe
  def initialize(store = {})
    @store = store
  end

  def add_entry(entry)
    unless entry.superior_to?(@store[entry.destination_vertex])
      # Return nothing
      return {
        did_insert: false,
        fringe: self,
      }
    end

    new_store = @store.dup
    new_store[entry.destination_vertex] = entry
    return {
      did_insert: true,
      fringe: Fringe.new(new_store),
    }
  end

  def extract
    best_entry = nil
    @store.each do |vertex, entry|
      best_entry = entry if entry.superior_to?(best_entry)
    end

    new_store = @store.dup
    new_store.delete(entry.destination_vertex)
    return {
      best_entry: best_entry,
      fringe: Fringe.new(new_store),
    }
  end

  def empty?
    @store.empty?
  end
end
