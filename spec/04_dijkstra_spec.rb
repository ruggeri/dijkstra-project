require 'fiber'

require_relative '../lib/00_graph.rb'
require_relative '../lib/01_result_entry.rb'
require_relative '../lib/02_result_map.rb'
require_relative '../lib/03_fringe.rb'
require_relative '../lib/04_dijkstra.rb'
require_relative '../lib/ff_messages.rb'

require_relative './graph.rb'

$vertices = build_graph
$start_vertex = $vertices["ATL"]


$fiber = Fiber.new do
  dijkstra($start_vertex)
end

describe "dijkstra" do
  it "starts by yielding initialization message" do
    msg = $fiber.resume

    expected_fringe = Fringe.new(
      { $vertices["ATL"] => ResultEntry.new(
          $vertices["ATL"],
          nil,
          0
        )
      }
    )

    expect(msg.name).to eq(:initialization)
    expect(msg.result).to eq(ResultMap.new)
    expect(msg.fringe).to eq(expected_fringe)
  end
end
