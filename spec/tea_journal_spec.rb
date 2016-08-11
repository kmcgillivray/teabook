require_relative '../models/tea_journal'

RSpec.describe TeaJournal do
  describe "attributes" do
    it "responds to entries" do
      journal = TeaJournal.new
      expect(journal).to respond_to(:entries)
    end

    it "initializes entries as an array" do
      journal = TeaJournal.new
      expect(journal.entries).to be_an(Array)
    end

    it "initializes entries as empty" do
      journal = TeaJournal.new
      expect(journal.entries.size).to eq(0)
    end
  end

  describe "#add_entry" do
    it "adds only one entry to the tea journal" do
      journal = TeaJournal.new
      journal.add_entry('Sencha', 'Green', 'Kyusu')

      expect(journal.entries.size).to eq(1)
    end

    it "adds the correct information to entries" do
      journal = TeaJournal.new
      journal.add_entry('Sencha', 'Green', 'Kyusu')
      new_entry = journal.entries[0]

      expect(new_entry.tea_name).to eq('Sencha')
      expect(new_entry.type).to eq('Green')
      expect(new_entry.brewing_method).to eq('Kyusu')
    end
  end
end
