require 'fiber'

require_relative '../lib/00_graph.rb'
require_relative '../lib/01_result_entry.rb'
require_relative '../lib/02_result_map.rb'
require_relative '../lib/03_fringe.rb'
require_relative '../lib/04_dijkstra.rb'
require_relative '../lib/ff_messages.rb'

require_relative './graph.rb'

graph = build_graph()
$vertices = graph[:vertices]
$edges = graph[:edges]
$start_vertex = $vertices["ATL"]

$fiber = Fiber.new do
  dijkstra($start_vertex)
end

describe "#dijkstra" do
  it "starts by yielding initialization message" do
    # Fringe should start with the source vertex.
    msg = $fiber.resume

    expected_fringe = Fringe.new(
      { $vertices["ATL"] => ResultEntry.new(
          $vertices["ATL"],
          nil,
          0
        ).to_hash
      }
    )

    expect(msg.name).to eq(:initialization)
    expect(msg.result_map.to_hash).to eq({})
    expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)
  end

  it "extracts the source vertex first" do
    msg = $fiber.resume

    best_entry = ResultEntry.new(
      $vertices["ATL"],
      nil,
      0
    )
    expected_result_map = ResultMap.new(
      { $vertices["ATL"] => best_entry }
    )
    expected_fringe = Fringe.new({})

    expect(msg.name).to eq(:extraction)
    expect(msg.result_map.to_hash).to eq(expected_result_map.to_hash)
    expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)
    expect(msg.best_entry.to_hash).to eq(best_entry.to_hash)
  end
end

describe "#add_vertex_edge" do
  let(:atlanta) { $vertices["ATL"] }
  let(:denver) { $vertices["DEN"] }
  let(:lax) { $vertices["LAX"] }

  let(:atl_den) { $edges["ATL_DEN"] }
  let(:atl_lax) { $edges["ATL_LAX"] }
  let(:dfw_atl) { $edges["DFW_ATL"] }

  let(:extracted_entry) do
    ResultEntry.new(atlanta, nil, 0)
  end

  let(:fringe) { Fringe.new }
  let(:result_map) do
    ResultMap.new(
      { atlanta => extracted_entry }
    )
  end

  let(:fiber) do
    Fiber.new { add_vertex_edges(result_map, fringe, extracted_entry) }
  end

  describe "adding first edge (atl to den)" do
    let(:expected_new_entry) do
      ResultEntry.new(
        denver,
        atl_den,
        atl_den.cost
      )
    end

    let(:expected_fringe) do
      Fringe.new({ denver => expected_new_entry })
    end

    it "doesn't change result" do
      msg = fiber.resume

      expect(msg.name).to eq(:edge_consideration)
      expect(msg.result_map.to_hash).to eq(result_map.to_hash)
    end

    it "builds a new entry" do
      msg = fiber.resume
      expect(msg.new_entry.to_hash).to eq(expected_new_entry.to_hash)
    end

    it "inserts new entry in fringe" do
      msg = fiber.resume
      expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)
    end

    it "tells us this was an insert" do
      msg = fiber.resume
      expect(msg.action).to eq(:insert)
    end
  end
end
