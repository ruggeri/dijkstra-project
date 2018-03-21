class ResultEntry
  attr_reader :destination_vertex, :last_edge, :cost_to_vertex

  def initialize(destination_vertex, last_edge, cost_to_vertex)
    @destination_vertex = destination_vertex
    @last_edge = last_edge
    @cost_to_vertex = cost_to_vertex
  end

  def superior_to?(other_entry)
    return true if other_entry.nil?

    other_vertex = other_entry.destination_vertex
    if destination_vertex != other_vertex
      raise "incompatible entries"
    end

    cost_to_vertex < other_entry.cost_to_vertex
  end

  def ==(other_re)
    ((destination_vertex == other_re.destination_vertex) &&
     (last_edge == other_re.last_edge) &&
     (cost_to_vertex == other_re.cost_to_vertex))
  end

  def to_s
    hash = {
      vertex: destination_vertex.name,
      last_edge: last_edge.name,
      cost_to_vertex: cost_to_vertex,
    }
  end
end
