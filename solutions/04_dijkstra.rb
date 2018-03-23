require_relative './01_result_entry'
require_relative './02_result_map'
require_relative './03_fringe'
require_relative './ff_messages'

def dijkstra(start_vertex)
  result_map = ResultMap.new
  fringe = Fringe.new

  fringe = fringe.add_entry(
    ResultEntry.new(start_vertex, nil, 0)
  )[:fringe]

  Fiber.yield InitializationMessage.new(result_map, fringe)

  until fringe.empty?
    best_entry, fringe = fringe.extract.values_at(
      :best_entry, :fringe
    )

    result_map = result_map.add_entry(best_entry)

    Fiber.yield ExtractionMessage.new(result_map, fringe, best_entry)

    fringe = add_vertex_edges(
      result_map, fringe, best_entry
    )

    Fiber.yield(
      UpdateCompletionMessage.new(result_map, fringe, best_entry)
    )
  end

  return result_map
end

def add_vertex_edges(result_map, fringe, best_entry)
  vertex = best_entry.destination_vertex
  vertex.edges.each do |edge|
    new_vertex = edge.other_vertex(vertex)
    new_entry = ResultEntry.new(
      new_vertex,
      edge,
      best_entry.cost_to_vertex + edge.cost
    )

    if result_map.has_vertex?(new_vertex)
      action = :result_map_has_vertex
    else
      action, fringe = (
        fringe.add_entry(new_entry).values_at(:action, :fringe)
      )
    end

    Fiber.yield(
      EdgeConsiderationMessage.new(
        result_map,
        fringe,
        new_entry,
        action,
      )
    )
  end

  return fringe
end
