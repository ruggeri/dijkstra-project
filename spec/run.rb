require 'byebug'
require 'fiber'
require 'pp'

require_relative './graph.rb'
require_relative '../lib/04_dijkstra.rb'

vertices = build_graph()[:vertices]
start_vertex = vertices["ATL"]

fiber = Fiber.new do
  dijkstra(start_vertex)
end

while fiber.alive?
  msg = fiber.resume
  puts "=" * 40
  pp msg.to_hash
  gets
end
