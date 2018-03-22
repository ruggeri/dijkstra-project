require 'fiber'

require_relative '../lib/00_graph.rb'
require_relative '../lib/01_result_entry.rb'
require_relative '../lib/02_result_map.rb'
require_relative '../lib/03_fringe.rb'
require_relative '../lib/04_dijkstra.rb'
require_relative '../lib/ff_messages.rb'

require_relative './graph.rb'

describe "dijkstra module" do
  # Graph/vertices/edges
  let(:graph) { build_graph }
  let(:vertices) { graph[:vertices] }
  let(:edges) { graph[:edges] }

  # Specific vertices
  let(:atlanta) { vertices["ATL"] }
  let(:denver) { vertices["DEN"] }
  let(:los_angeles) { vertices["LAX"] }
  let(:dallas) { vertices["DFW"] }

  # Specific edges
  let(:atl_den) { edges["ATL_DEN"] }
  let(:atl_lax) { edges["ATL_LAX"] }
  let(:dfw_atl) { edges["DFW_ATL"] }

  # Specific ResultEntries
  let(:expected_atlanta_entry) do
    ResultEntry.new(atlanta, nil, 0)
  end
  let(:expected_denver_entry) do
    ResultEntry.new(denver, atl_den, atl_den.cost)
  end
  let(:expected_lax_entry) do
    ResultEntry.new(los_angeles, atl_lax, atl_lax.cost)
  end
  let(:expected_dallas_entry) do
    ResultEntry.new(dallas, dfw_atl, dfw_atl.cost)
  end

  describe "#dijkstra (round one)" do
    let(:fiber) do
      Fiber.new { dijkstra(atlanta) }
    end

    it "starts by yielding initialization message" do
      # Fringe should start with the source vertex.
      msg = fiber.resume

      expected_fringe = Fringe.new(
        { atlanta => expected_atlanta_entry }
      )

      expect(msg.name).to eq(:initialization)
      expect(msg.result_map.to_hash).to eq({})
      expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)
    end

    it "extracts the source vertex next" do
      _ = fiber.resume
      msg = fiber.resume

      expected_result_map = ResultMap.new(
        { atlanta => expected_atlanta_entry }
      )
      expected_fringe = Fringe.new({})

      expect(msg.name).to eq(:extraction)
      expect(msg.result_map.to_hash).to eq(expected_result_map.to_hash)
      expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)
      expect(msg.best_entry.to_hash).to eq(expected_atlanta_entry.to_hash)
    end
  end

  describe "#add_vertex_edge" do
    let(:initial_fringe) { Fringe.new }
    let(:initial_result_map) do
      ResultMap.new(
        { atlanta => expected_atlanta_entry }
      )
    end

    let(:fiber) do
      Fiber.new do
        add_vertex_edges(
          initial_result_map, initial_fringe, expected_atlanta_entry)
      end
    end

    describe "inserting first edge (atl to den)" do
      it "doesn't change result map" do
        msg = fiber.resume

        expect(msg.name).to eq(:edge_consideration)
        expect(msg.result_map.to_hash).to eq(initial_result_map.to_hash)
      end

      it "builds a new entry" do
        msg = fiber.resume
        expect(msg.new_entry.to_hash).to eq(expected_denver_entry.to_hash)
      end

      it "inserts new entry in fringe" do
        msg = fiber.resume
        expected_fringe = Fringe.new(
          { denver => expected_denver_entry }
        )
        expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)
      end

      it "tells us this was an insert" do
        msg = fiber.resume
        expect(msg.action).to eq(:insert)
      end
    end

    describe "inserting second edge (atl to lax)" do
      before do
        # Burn first message (checked it before).
        _ = fiber.resume
      end

      it "doesn't change result map" do
        msg = fiber.resume

        expect(msg.name).to eq(:edge_consideration)
        expect(msg.result_map.to_hash).to eq(initial_result_map.to_hash)
      end

      it "builds a new entry" do
        msg = fiber.resume
        expect(msg.new_entry.to_hash).to eq(expected_lax_entry.to_hash)
      end

      it "inserts new entry in fringe" do
        msg = fiber.resume
        expected_fringe = Fringe.new(
          { denver => expected_denver_entry,
            los_angeles => expected_lax_entry,
          }
        )

        expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)
      end

      it "tells us this was an insert" do
        msg = fiber.resume
        expect(msg.action).to eq(:insert)
      end
    end

    describe "inserting third edge (dfw to atl)" do
      before do
        # Burn first two messages (checked it before).
        _ = fiber.resume
        _ = fiber.resume
      end

      it "doesn't change result map" do
        msg = fiber.resume

        expect(msg.name).to eq(:edge_consideration)
        expect(msg.result_map.to_hash).to eq(initial_result_map.to_hash)
      end

      it "builds a new entry" do
        msg = fiber.resume
        expect(msg.new_entry.to_hash).to eq(expected_dallas_entry.to_hash)
      end

      it "inserts new entry in fringe" do
        msg = fiber.resume
        expected_fringe = Fringe.new(
          { denver => expected_denver_entry,
            los_angeles => expected_lax_entry,
            dallas => expected_dallas_entry
          }
        )

        expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)
      end

      it "tells us this was an insert" do
        msg = fiber.resume
        expect(msg.action).to eq(:insert)
      end
    end

    describe "completion" do
      it "finishes after three inserts" do
        _ = fiber.resume
        _ = fiber.resume
        _ = fiber.resume

        new_fringe = fiber.resume

        expected_new_fringe = Fringe.new(
          { denver => expected_denver_entry,
            los_angeles => expected_lax_entry,
            dallas => expected_dallas_entry,
          }
        )

        expect(new_fringe.to_hash).to eq(expected_new_fringe.to_hash)
      end
    end
  end

  describe "#dijkstra (round two)" do
    let(:fiber) do
      Fiber.new { dijkstra(atlanta) }
    end

    let(:msg) do
      # initial message
      _ = fiber.resume
      # atl extraction
      _ = fiber.resume
      # three updates
      _ = fiber.resume
      _ = fiber.resume
      _ = fiber.resume

      # competion message
      msg = fiber.resume
    end

    it "yields msg after considering all edges of extracted vertex" do
      expect(msg.name).to eq(:update_completion)

      expected_result_map = ResultMap.new(
        { atlanta => expected_atlanta_entry }
      )
      expect(msg.result_map.to_hash).to eq(expected_result_map.to_hash)

      expected_fringe = Fringe.new(
        { denver => expected_denver_entry,
          los_angeles => expected_lax_entry,
          dallas => expected_dallas_entry,
        }
      )
      expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)

      expect(msg.best_entry.to_hash).to(
        eq(expected_atlanta_entry.to_hash)
      )
    end
  end
end
