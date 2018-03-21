class ResultEntry
  attr_reader :destination_vertex, :lastEdge, :cost_to_vertex

  def initialize(destination_vertex, last_edge, cost_to_vertex)
    @destination_vertex = destination_vertex
    @last_edge = last_edge
    @cost_to_vertex = cost_to_vertex
  end

  def superior_to?(other_entry)
    unless destination_vertex == other_entry.destination_vertex
      raise "incompatible entries"
    end

    cost_to_vertex < other_entry.cost_to_vertex
  end
end
