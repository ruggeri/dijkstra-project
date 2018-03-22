require_relative './01_result_entry'
require_relative './02_result_map'
require_relative './03_fringe'
require_relative './ff_messages'

def dijkstra(start_vertex)
  # 1. Start empty result map and fringe with start vertex. Yield
  # initialization message.

  until fringe.empty?
    # 2. Extract the minimum cost entry from the fringe. Add it to the
    # result. Yield extraction message.

    # 3. Process all outgoing edges from the vertex.

    # 4. When done, yield competion message.
  end

  # 5. When all done, return the result map.
end

def add_vertex_edges(result_map, fringe, best_entry)
  # 1. Iterate through each edge of the extracted vertex.

  # 2. For each edge, build a candidate result entry for the new
  # vertex on the other side.

  # 2a. Skip if we already have the new vertex in the visited set.
  # 2b. Else try to add the edge to the fringe. Yield an edge
  # consideration message.

  # 3. When all done, return the updated fringe.
end
