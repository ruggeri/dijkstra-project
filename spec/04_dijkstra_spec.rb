require 'fiber'

require_relative './graph.rb'
require_relative '../lib/04_dijkstra.rb'

vertices = graph()
start_vertex = vertices["ATL"]

fiber = Fiber.new do
  dijkstra(start_vertex)
end

while fiber.alive?
  msg = fiber.resume

  p msg
end
