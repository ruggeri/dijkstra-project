require_relative '../lib/00_graph.rb'
require_relative '../lib/01_result_entry.rb'

describe ResultEntry do
  let(:v1) do
    UndirectedVertex.new("v1")
  end

  let(:v2) do
    UndirectedVertex.new("v2")
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

  describe "#initialize" do
    it "adds destination_vertex attribute" do
      expect(entry1.destination_vertex.to_hash).to eq(v2.to_hash)
    end

    it "adds last_edge attribute" do
      expect(entry1.last_edge.to_hash).to eq(e.to_hash)
    end

    it "adds cost_to_vertex attribute" do
      expect(entry1.cost_to_vertex).to eq(123)
    end
  end

  describe "implements superior_to?" do
    it "compares favorably to nil" do
      expect(entry1.superior_to?(nil)).to be(true)
    end

    it "compares favorably to higher cost entry" do
      expect(entry1.superior_to?(entry2)).to be(true)
    end

    it "compares unfavorably to lower cost entry" do
      expect(entry2.superior_to?(entry1)).to be(false)
    end
  end
end
