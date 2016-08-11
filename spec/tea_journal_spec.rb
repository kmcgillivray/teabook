require_relative '../models/tea_journal'

RSpec.describe TeaJournal do

  let(:journal) { TeaJournal.new }

  def check_entry(entry, expected_name, expected_type, expected_method)
    expect(entry.tea_name).to eq expected_name
    expect(entry.type).to eq expected_type
    expect(entry.brewing_method).to eq expected_method
  end

  describe "attributes" do
    it "responds to entries" do
      expect(journal).to respond_to(:entries)
    end

    it "initializes entries as an array" do
      expect(journal.entries).to be_an(Array)
    end

    it "initializes entries as empty" do
      expect(journal.entries.size).to eq(0)
    end
  end

  describe "#add_entry" do
    it "adds only one entry to the tea journal" do
      journal.add_entry('Sencha', 'Green', 'Kyusu')

      expect(journal.entries.size).to eq(1)
    end

    it "adds the correct information to entries" do
      journal.add_entry('Sencha', 'Green', 'Kyusu')
      new_entry = journal.entries[0]

      expect(new_entry.tea_name).to eq('Sencha')
      expect(new_entry.type).to eq('Green')
      expect(new_entry.brewing_method).to eq('Kyusu')
    end
  end

  describe "#remove_entry" do
    it "removes only one entry from the tea journal" do
      journal = TeaJournal.new
      journal.add_entry('Sencha', 'Green', 'Kyusu')
      journal.add_entry('English Breakfast', 'Black', 'Ceramic teapot')
      expect(journal.entries.size).to eq(2)

      journal.remove_entry('English Breakfast', 'Black', 'Ceramic teapot')
      expect(journal.entries.size).to eq(1)
    end
  end

  describe "#import_from_csv" do
    it "imports the corrent number of entries" do
      journal.import_from_csv("entries.csv")
      journal_size = journal.entries.size

      expect(journal_size).to eq(5)
    end

    it "imports the the correct data for all entries" do
      journal.import_from_csv("entries.csv")
      expected_data = [
        ["Sencha","Green","Kyusu"],
        ["English Breakfast","Black","Ceramic teapot"],
        ["Meng Ding Huangya","Yellow","Gaiwan"],
        ["Irish Breakfast","Black","Ceramic teapot"],
        ["Matcha","Green","Tea bowl"]
      ]

      journal.entries.each_with_index do |entry, index|
        expected_entry_data = expected_data[index]
        check_entry(entry, expected_entry_data[0], expected_entry_data[1], expected_entry_data[2])
      end
    end
  end

  describe "import from entries_2.csv" do
    it "imports the corrent number of entries" do
      journal.import_from_csv("entries_2.csv")
      journal_size = journal.entries.size

      expect(journal_size).to eq(3)
    end

    it "imports the the correct data for all entries" do
      journal.import_from_csv("entries_2.csv")
      expected_data = [
        ["Silver Needle","White","Brew basket"],
        ["Lu An Gua Pian","Green","Brew basket"],
        ["Jasmine","Green","Brew basket"]
      ]

      journal.entries.each_with_index do |entry, index|
        expected_entry_data = expected_data[index]
        check_entry(entry, expected_entry_data[0], expected_entry_data[1], expected_entry_data[2])
      end
    end
  end
end
