class ResultMap
  def initialize(store = {})
  end

  def add_entry(entry)
  end

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
