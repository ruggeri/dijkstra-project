require './01_result_entry'
require './02_result_map'
require './03_fringe'
require './ff_messages'

def dijkstra(start_vertex)
  result = ResultMap.new
  fringe = Fringe.new

  fringe = fringe.add_entry(
    ResultEntry.new(destination_vertex, nil, 0)
  )[:fringe]

  Fiber.yield InitializationMessage.new(result, fringe)

  until fringe.empty?
    [best_entry, fringe] = fringe.extract.values_at(
      :best_entry, :fringe
    )

    result = result.add_entry(best_entry)

    Fiber.yield ExtractionMessage.new(result, fringe, best_entry)

    fringe = add_vertex_edges(
      result, fringe, best_entry
    )

    Fiber.yield UpdateCompletionMessage.new(result, fringe, best_entry)
  end

  return result
end

def add_vertex_edges(result, fringe, best_entry)
  vertex = best_entry.destination_vertex
  vertex.edges.each do |edge|
    new_vertex = edge.other_vertex(vertex)
    new_entry = ResultEntry.new(
      new_vertex,
      edge,
      best_entry.cost_to_vertex + edge.cost
    )

    if result.has_vertex?(vertex)
      action = :result_has_vertex
    else
      action, fringe = (
        fringe.add_entry(new_entry).values_at(:action, :fringe)
      )
    end

    Fiber.yield(
      EdgeConsiderationMessage.new(
        result,
        fringe,
        new_entry,
        action,
      )
    )
  end
end
