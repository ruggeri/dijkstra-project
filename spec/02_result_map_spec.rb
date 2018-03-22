require_relative '../lib/00_graph.rb'
require_relative '../lib/01_result_entry.rb'
require_relative '../lib/02_result_map.rb'

describe ResultMap do
  let(:v1) do
    UndirectedVertex.new("v1")
  end

  let(:v2) do
    UndirectedVertex.new("v2")
  end

  let(:v3) do
    UndirectedVertex.new("v3")
  end

  let(:e) do
    UndirectedEdge.new("e", v1, v2, 123)
  end

  let(:entry1) do
    ResultEntry.new(
      v2,
      e,
      123
    )
  end

  let(:entry2) do
    ResultEntry.new(
      v2,
      e,
      456
    )
  end

  let(:entry3) do
    ResultEntry.new(
      v3,
      e,
      789
    )
  end

  let(:result_map) do
    ResultMap.new
  end

  describe "#initialize" do
    it "starts with empty store" do
      expect(result_map.send(:store)).to eq({})
    end
  end

  describe "#add_entry" do
    it "does not mutate" do
      result_map.add_entry(entry1)
      expect(result_map.to_hash).to eq({})
    end


    it "stores entries under vertex name" do
      new_result_map = result_map.add_entry(
        entry1
      )

      expected_store = {
        entry1.destination_vertex.name => entry1.to_hash
      }
      expect(new_result_map.to_hash).to eq(expected_store.to_hash)
    end

    it "cannot add same vertex twice" do
      (expect do
         new_result_map = result_map.add_entry(entry1)
         new_result_map.add_entry(entry2)
      end).to raise_error("Cannot add entry for same vertex twice!")
    end
  end

  describe "#has_vertex?" do
    it "finds a vertex in the map" do
      new_result_map = result_map.add_entry(entry1)
      new_result_map = new_result_map.add_entry(entry3)

      expect(new_result_map.has_vertex?(v1)).to be(false)
      expect(new_result_map.has_vertex?(v2)).to be(true)
      expect(new_result_map.has_vertex?(v3)).to be(true)
    end
  end
end
