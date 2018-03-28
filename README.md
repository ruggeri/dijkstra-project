[Dijkstra Demo](https://ruggeri.github.io/dijkstra-demo/)

**Overview**

0. `00_graph.rb` contains code for `UndirectedVertex` and
   `UndirectedEdge` classes. You don't need to do anything with it.
1. `01_result_entry.rb` has you define `ResultEntry`. Entries store a
   vertex, the last edge in the best path to the vertex, and the total
   cost of the path. An entry A is superior to an entry B when (0)
   entry B is `nil`, i.e., no entry, (1) they both go to the same
   vertex, (2) entry A has lower cost than entry B.
2. `02_result_map.rb` has you build the structure that will store the
   final result of the algorithm. `ResultMap` should be **immutable**,
   which means the `add_entry` method should not modify the store, but
   instead create a new store and a new `ResultMap`.
3. `03_fringe.rb` implements your fringe, which is the set of vertices
   you'll choose from when picking the next entry/path to "lock in"
   and move to the `ResultMap`. You main methods are `add_entry`,
   which adds if the new entry is superior to whatever you had prior
   for that vertex in the fringe. `extract` removes the lowest cost
   entry from the fringe.
4. `Fringe` is also **immutable**. `add_entry` and `extract` should
   not mutate the store; you must create a copy of the store before
   mutating it and building a new `Fringe` object. Since `extract`
   asks you to return *two* things (the lowest cost entry plus the new
   fringe), return a map of shape `{ best_entry: be, fringe: f }`.
5. Likewise, for `add_entry`, return a map of shape `{ action: a,
   fringe: f }`. `action` should be `:old_entry_better`, `:insert`, or
   `:update`. This "tells" the caller of `add_entry` what you did.

**04_dijkstra**

Dijkstra's algorithm is broken into two parts: `dijkstra` and
`add_vertex_edges`.

The algorithm asks you to use `Fiber.yield` as your algorithm
runs. This works like a generator function from JavaScript. Your
function pauses at `Fiber.yield`. My specs look at the message, which
allows them to verify what you are doing. When my spec has verified
that, it will continue running your code by saying `fiber.resume`.

Messages that you should use are defined in `ff_messages.rb`. You do
not need to write any code there.

The `#dijkstra` method builds the fringe and result map. It then
loops, extracting the best entry from the fringe each time. To update
the fringe, it calls `#add_vertex_edges`.

`#add_vertex_edges` updates the fringe. It iterates through the edges
of the newly locked in vertex. It builds new entries for each edge and
considers whether it should be added to the fringe.

When all done, return (don't yield) the final result map.

**Good luck!**
