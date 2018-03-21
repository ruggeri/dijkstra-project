require_relative './graph.rb'
require_relative '../lib/04_dijkstra.rb'

vertices = graph()
start_vertex = vertices["ATL"]

dijkstra(start_vertex)
