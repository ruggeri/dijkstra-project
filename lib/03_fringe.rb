class Fringe
  def initialize(store = {})
  end

  def add_entry(entry)
  end

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
