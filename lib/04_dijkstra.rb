require_relative './01_result_entry'
require_relative './02_result_map'
require_relative './03_fringe'
require_relative './ff_messages'

# This method will have you call Fiber.yield to yield various messages
# (listed in ff_messages) to indicate what your algorithm is doing
# along the way.
def dijkstra(start_vertex)
  # 1. Start empty result map and fringe with just the start
  # vertex. Yield initialization message.

  # 2. Each time, extract the minimum cost entry from the fringe. Add
  # it to the result. Yield extraction message.

  # 3. Process all outgoing edges from the vertex by using
  # add_vertex_edges.

  # 4. When done processing edges for the extracted entry, yield
  # competion message.

  # 5. When entirely all done, *return* (not yield) the result map.
end

def add_vertex_edges(result_map, fringe, best_entry)
  # 1. Iterate through each edge of the extracted vertex (call this
  # vertex_a).

  # 2. For each edge, build a candidate result entry for the vertex on
  # the other side of the edge (call this vertex_b).

  # 2a. Skip if we already have vertex_b in the visited set. Yield an
  # EdgeConsiderationMessage of :result_map_has_vertex.

  # 2b. Else try to add the edge to the fringe. Yield an edge
  # consideration message with the action set to the outcome of the
  # attempted insertion into the fringe.

  # 3. When all done with the edges of vertex_a, return the updated
  # fringe.
end
