require_relative '../lib/00_graph.rb'

VERTEX_NAMES = [
  "ATL",
  "LAX",
  "ORD",
  "DFW",
  "JFK",
  "DEN",
  "SFO",
  "LAS",
  "CLT",
  "SEA",
];

EDGES = [
  ["DFW", "LAS", 3.6],
  ["JFK", "LAS", 3.9],
  ["LAS", "SEA", 3.6],
  ["SEA", "DFW", 3.3],
  ["DFW", "ATL", 9.9],
  ["SFO", "SEA", 3.4],
  ["JFK", "SFO", 5.1],
  ["ORD", "JFK", 6.8],
  ["ORD", "SFO", 4.1],
  ["ATL", "DEN", 3.7],
  ["ATL", "LAX", 6.1],
  ["CLT", "ORD", 4.7],
  ["DEN", "LAX", 3.8],
  ["LAX", "CLT", 2.9],
  ["DEN", "CLT", 11.8],
]

def graph()
  vertices = {}

  VERTEX_NAMES.each { |name|
    vertices[name] = UndirectedVertex.new(name)
  }

  EDGES.each do |edge_data|
    name1, name2, cost = edge_data
    UndirectedEdge.new(
      "#{name1}_#{name2}",
      vertices[name1],
      vertices[name2],
      cost,
    )
  end

  return vertices
end
