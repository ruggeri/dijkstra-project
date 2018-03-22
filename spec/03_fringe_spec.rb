require_relative '../lib/00_graph.rb'
require_relative '../lib/01_result_entry.rb'
require_relative '../lib/03_fringe.rb'

describe Fringe do
  let(:v1) do
    UndirectedVertex.new("v1")
  end

  let(:v2) do
    UndirectedVertex.new("v2")
  end

  let(:v3) do
    UndirectedVertex.new("v3")
  end

  let(:v4) do
    UndirectedVertex.new("v4")
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

  let(:entry4) do
    ResultEntry.new(
      v4,
      e,
      999
    )
  end

  let(:fringe) do
    Fringe.new
  end

  describe "#initialize" do
    it "starts with empty store" do
      expect(fringe.send(:store)).to eq({})
    end
  end

  describe "#add_entry" do
    it "does not mutate" do
      fringe.add_entry(entry1)
      expect(fringe.send(:store)).to eq({})
    end

    it "returns map with two keys" do
      add_entry_result = fringe.add_entry(entry1)

      expect(add_entry_result).to have_key(:action)
      expect(add_entry_result).to have_key(:fringe)
    end


    it "stores entries under vertex name" do
      add_entry_result = fringe.add_entry(
        entry1
      )

      new_fringe = add_entry_result[:fringe]
      action = add_entry_result[:action]

      expected_store = {
        entry1.destination_vertex => entry1
      }
      expect(new_fringe.send(:store)).to eq(expected_store)
      expect(action).to eq(:insert)
    end

    it "replaces an inferior entry" do
      new_fringe = fringe.add_entry(entry2)[:fringe]

      add_entry_result = new_fringe.add_entry(entry1)

      new_fringe = add_entry_result[:fringe]
      action = add_entry_result[:action]

      expected_store = {
        entry1.destination_vertex => entry1
      }
      expect(new_fringe.send(:store)).to eq(expected_store)
      expect(action).to eq(:update)
    end

    it "keeps a superior entry" do
      new_fringe = fringe.add_entry(entry1)[:fringe]

      add_entry_result = new_fringe.add_entry(entry2)

      new_fringe = add_entry_result[:fringe]
      action = add_entry_result[:action]

      expected_store = {
        entry1.destination_vertex => entry1
      }
      expect(new_fringe.send(:store)).to eq(expected_store)
      expect(action).to eq(:old_entry_better)
    end
  end

  describe "extract" do
    let(:full_fringe) do
      new_fringe = fringe.add_entry(entry3)[:fringe]
      new_fringe = new_fringe.add_entry(entry2)[:fringe]
      new_fringe = new_fringe.add_entry(entry4)[:fringe]

      new_fringe
    end

    it "returns two keys" do
      add_entry_result = full_fringe.extract

      expect(add_entry_result).to have_key(:best_entry)
      expect(add_entry_result).to have_key(:fringe)
    end

    it "extracts the min cost key" do
      e = full_fringe.extract[:best_entry]

      expect(e).to eq(entry2)
    end

    it "returns a new fringe" do
      new_fringe = full_fringe.extract[:fringe]

      expected_store = {
        entry3.destination_vertex => entry3,
        entry4.destination_vertex => entry4,
      }

      expect(new_fringe.send(:store)).to eq(expected_store)
    end

    it "does not mutate old fringe" do
      full_fringe.extract

      expected_store = {
        entry2.destination_vertex => entry2,
        entry3.destination_vertex => entry3,
        entry4.destination_vertex => entry4,
      }

      expect(full_fringe.send(:store)).to eq(expected_store)
    end

    it "handles repeated extraction" do
      add_entry_result1 = full_fringe.extract
      add_entry_result2 = add_entry_result1[:fringe].extract
      add_entry_result3 = add_entry_result2[:fringe].extract
      new_fringe = add_entry_result3[:fringe]

      expected_store = {}

      expect(new_fringe.send(:store)).to eq({})
      expect(add_entry_result1[:best_entry]).to eq(entry2)
      expect(add_entry_result2[:best_entry]).to eq(entry3)
      expect(add_entry_result3[:best_entry]).to eq(entry4)
    end
  end

  describe "#empty?" do
    it "returns true when empty" do
      expect(fringe.empty?).to be(true)
    end

    it "returns false when not empty" do
      new_fringe = fringe.add_entry(entry1)[:fringe]
      expect(new_fringe.empty?).to be(false)
    end
  end
end
