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

  describe "#iterative_search" do
    it "returns an array of results" do
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Sencha")
      expect(entries).to be_a Array
    end

    it "searches Teabook for a non-existent entry" do
      journal.import_from_csv("entries.csv")
      # Unlikely to find herbal teas in my tea journal...
      entries = journal.iterative_search("Youthberry")
      expect(entries.first).to be_nil
    end

    it "searches Teabook for Sencha" do
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Sencha")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "Sencha", "Green", "Kyusu")
    end

    it "searches Teabook for English Breakfast" do
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("English Breakfast")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "English Breakfast", "Black", "Ceramic teapot")
    end

    it "searches Teabook for Meng Ding Huangya" do
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Meng Ding Huangya")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "Meng Ding Huangya", "Yellow", "Gaiwan")
    end

    it "searches Teabook for Irish Breakfast" do
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Irish Breakfast")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "Irish Breakfast", "Black", "Ceramic teapot")
    end

    it "searches Teabook for Matcha" do
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Matcha")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "Matcha", "Green", "Tea bowl")
    end

    it "searches Teabook for Senchi" do
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Senchi")
      expect(entries.first).to be_nil
    end

    it "returns multiple results for English Breakfast" do
      journal.import_from_csv("entries.csv")
      journal.add_entry("English Breakfast", "Black", "Tea basket")
      entries = journal.iterative_search("English Breakfast")

      expect(entries.size).to eq(2)
    end

    it "returns returns the correct data when finding multiple results" do
      journal.import_from_csv("entries.csv")
      journal.add_entry("English Breakfast", "Black", "Tea basket")
      entries = journal.iterative_search("English Breakfast")

      check_entry(entries.first, "English Breakfast", "Black", "Ceramic teapot")
      check_entry(entries.last, "English Breakfast", "Black", "Tea basket")
    end
  end
end
