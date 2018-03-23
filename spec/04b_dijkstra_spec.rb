require 'fiber'

require_relative '../lib/00_graph.rb'
require_relative '../lib/01_result_entry.rb'
require_relative '../lib/02_result_map.rb'
require_relative '../lib/03_fringe.rb'
require_relative '../lib/04_dijkstra.rb'
require_relative '../lib/ff_messages.rb'

require_relative './graph.rb'

# TODO: Must test how they handle when edge is already in the result
# map, or if a better edge already exists.

describe "dijkstra" do
  # Graph/vertices/edges
  let(:graph) { build_graph }
  let(:vertices) { graph[:vertices] }
  let(:edges) { graph[:edges] }

  # Specific vertices
  let(:atlanta) { vertices["ATL"] }
  let(:dallas) { vertices["DFW"] }
  let(:denver) { vertices["DEN"] }
  let(:los_angeles) { vertices["LAX"] }
  let(:charlotte) { vertices["CLT"] }

  # Specific edges
  let(:atl_den) { edges["ATL_DEN"] }
  let(:atl_lax) { edges["ATL_LAX"] }
  let(:dfw_atl) { edges["DFW_ATL"] }
  let(:den_lax) { edges["DEN_LAX"] }
  let(:den_clt) { edges["DEN_CLT"] }

  # Result Entries
  let(:atlanta_entry) do
    ResultEntry.new(
      atlanta,
      nil,
      0,
    )
  end
  let(:denver_entry) do
    ResultEntry.new(
      denver,
      atl_den,
      atl_den.cost
    )
  end

  # Fringe Entries
  let(:lax_entry) do
    ResultEntry.new(
      los_angeles,
      atl_lax,
      atl_lax.cost,
    )
  end
  let(:dallas_entry) do
    ResultEntry.new(
      dallas,
      dfw_atl,
      dfw_atl.cost,
    )
  end
  let(:expected_new_clt_entry) do
    ResultEntry.new(
      charlotte,
      den_clt,
      atl_den.cost + den_clt.cost,
    )
  end

  describe "#add_vertex_edge" do
    let(:initial_fringe) do
      Fringe.new(
        { los_angeles => lax_entry,
          dallas => dallas_entry,
        }
      )
    end

    let(:initial_result_map) do
      ResultMap.new(
        { atlanta => atlanta_entry,
          denver => denver_entry,
        }
      )
    end

    let(:fiber) do
      Fiber.new do
        add_vertex_edges(
          initial_result_map, initial_fringe, denver_entry
        )
      end
    end

    describe "inserting first edge (den to atl)" do
      let(:new_atl_entry) do
        ResultEntry.new(
          atlanta,
          atl_den,
          atl_den.cost + atl_den.cost # here and back!
        )
      end

      it "doesn't change result map" do
        msg = fiber.resume

        expect(msg.name).to eq(:edge_consideration)
        expect(msg.result_map.to_hash).to eq(initial_result_map.to_hash)
      end

      it "builds a new entry" do
        msg = fiber.resume
        expect(msg.new_entry.to_hash).to eq(new_atl_entry.to_hash)
      end

      it "skips entry already in result" do
        msg = fiber.resume
        expect(msg.fringe.to_hash).to eq(initial_fringe.to_hash)
      end

      it "tells us this was a skip for entry in result" do
        msg = fiber.resume
        expect(msg.action).to eq(:result_map_has_vertex)
      end
    end

    describe "inserting second edge (den to clt)" do
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
        expect(msg.new_entry.to_hash).to eq(expected_new_clt_entry.to_hash)
      end

      it "inserts new entry in fringe" do
        msg = fiber.resume
        expected_new_fringe = Fringe.new(
          { los_angeles => lax_entry,
            dallas => dallas_entry,
            charlotte => expected_new_clt_entry,
          }
        )

        expect(msg.fringe.to_hash).to eq(expected_new_fringe.to_hash)
      end

      it "tells us this was an insert" do
        msg = fiber.resume
        expect(msg.action).to eq(:insert)
      end
    end

    describe "inserting third edge (den to lax)" do
      let(:expected_lax_entry) do
        ResultEntry.new(
          los_angeles,
          den_lax,
          atl_den.cost + den_lax.cost
        )
      end

      let(:expected_fringe) do
        expected_new_fringe = Fringe.new(
          { los_angeles => lax_entry,
            dallas => dallas_entry,
            charlotte => expected_new_clt_entry,
          }
        )
      end

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
        expect(msg.new_entry.to_hash).to eq(expected_lax_entry.to_hash)
      end

      it "does not insert inferior entry into fringe" do
        msg = fiber.resume
        expect(msg.fringe.to_hash).to eq(expected_fringe.to_hash)
      end

      it "tells us this was a skip" do
        msg = fiber.resume
        expect(msg.action).to eq(:old_entry_better)
      end
    end
  end
end
