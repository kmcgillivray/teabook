require_relative '../models/tea_journal'
require_relative '../models/entry'
require 'csv'

RSpec.describe TeaJournal do

  DATA_FILE = 'data_test.csv'
  let(:journal) { TeaJournal.new(DATA_FILE) }

  def check_entry(entry, expected_name, expected_type, expected_method)
    expect(entry.tea_name).to eq expected_name
    expect(entry.type).to eq expected_type
    expect(entry.brewing_method).to eq expected_method
  end

  def reset_data
    CSV.open(DATA_FILE, "w") do |csv|
      csv << ["tea_name", "type" , "brewing_method"]
      csv << ["Sencha", "Green", "Kyusu"]
    end

    journal.load_data
  end

  describe "attributes" do
    it "responds to entries" do
      expect(journal).to respond_to(:entries)
    end

    it "responds to data_file" do
      expect(journal).to respond_to(:data_file)
    end

    it "initializes entries as an array" do
      expect(journal.entries).to be_an(Array)
    end

    it "initializes entries as empty" do
      expect(journal.entries.size).to eq(0)
    end

    it "initializes with a data file" do
      expect(journal.data_file).to eq('data_test.csv')
    end
  end

  describe "#load_data" do
    it "loads the CSV data into entries" do
      reset_data

      expect(journal.entries.size).to eq(1)
    end

    it "loads the correct data" do
      reset_data
      test_entry = journal.entries[0]

      check_entry(test_entry, 'Sencha', 'Green', 'Kyusu')
    end
  end

  describe "#add_entry" do
    it "adds only one entry to the tea journal" do
      reset_data
      journal.add_entry('Gyokuro', 'Green', 'Kyusu')

      expect(journal.entries.size).to eq(2)
    end

    it "adds the correct information to entries" do
      reset_data
      journal.add_entry('Gyokuro', 'Green', 'Kyusu')
      test_entry = journal.entries[1]

      check_entry(test_entry, 'Gyokuro', 'Green', 'Kyusu')
    end

    it "writes to the data file" do
      reset_data
      original_numrows = CSV.readlines(journal.data_file).size
      journal.add_entry('Sencha', 'Green', 'Kyusu')
      new_numrows = CSV.readlines(journal.data_file).size

      expect(new_numrows).to eq(original_numrows + 1)
    end
  end

  describe "#remove_entry" do
    it "removes only one entry from the tea journal" do
      reset_data
      journal.add_entry('English Breakfast', 'Black', 'Ceramic teapot')
      expect(journal.entries.size).to eq(2)

      journal.remove_entry('English Breakfast', 'Black', 'Ceramic teapot')
      expect(journal.entries.size).to eq(1)
    end

    it "deletes the entry from the data file" do
      reset_data
      journal.remove_entry('Sencha', 'Green', 'Kyusu')
      new_numrows = CSV.readlines(journal.data_file).size

      expect(new_numrows).to eq(1)
    end

    it "deletes the correct data from the journal entries" do
      reset_data
      journal.add_entry('English Breakfast', 'Black', 'Ceramic teapot')
      journal.remove_entry('Sencha', 'Green', 'Kyusu')
      first_entry = journal.entries.first

      check_entry(first_entry, 'English Breakfast', 'Black', 'Ceramic teapot')
    end

    it "deletes the correct data from the data file" do
      reset_data
      journal.add_entry('English Breakfast', 'Black', 'Ceramic teapot')
      journal.remove_entry('Sencha', 'Green', 'Kyusu')
      csv_array = CSV.read(journal.data_file)

      expect(csv_array[1]).to eq(['English Breakfast', 'Black', 'Ceramic teapot'])
    end
  end

  describe "#import_from_csv" do
    it "imports the corrent number of entries" do
      reset_data
      journal.import_from_csv("entries.csv")
      journal_size = journal.entries.size

      expect(journal_size).to eq(6)
    end

    it "imports the the correct data for all entries" do
      reset_data
      journal.import_from_csv("entries.csv")
      expected_data = [
        ["Sencha","Green","Kyusu"],
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
      reset_data
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Sencha")
      expect(entries).to be_a Array
    end

    it "searches Teabook for a non-existent entry" do
      reset_data
      journal.import_from_csv("entries.csv")
      # Unlikely to find herbal teas in my tea journal...
      entries = journal.iterative_search("Youthberry")
      expect(entries.first).to be_nil
    end

    it "searches Teabook for Sencha" do
      reset_data
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Sencha")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "Sencha", "Green", "Kyusu")
    end

    it "searches Teabook for English Breakfast" do
      reset_data
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("English Breakfast")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "English Breakfast", "Black", "Ceramic teapot")
    end

    it "searches Teabook for Meng Ding Huangya" do
      reset_data
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Meng Ding Huangya")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "Meng Ding Huangya", "Yellow", "Gaiwan")
    end

    it "searches Teabook for Irish Breakfast" do
      reset_data
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Irish Breakfast")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "Irish Breakfast", "Black", "Ceramic teapot")
    end

    it "searches Teabook for Matcha" do
      reset_data
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Matcha")
      first_result = entries.first
      expect(first_result).to be_a Entry
      check_entry(first_result, "Matcha", "Green", "Tea bowl")
    end

    it "searches Teabook for Senchi" do
      reset_data
      journal.import_from_csv("entries.csv")
      entries = journal.iterative_search("Senchi")
      expect(entries.first).to be_nil
    end

    it "returns multiple results for English Breakfast" do
      reset_data
      journal.import_from_csv("entries.csv")
      journal.add_entry("English Breakfast", "Black", "Tea basket")
      entries = journal.iterative_search("English Breakfast")

      expect(entries.size).to eq(2)
    end

    it "returns returns the correct data when finding multiple results" do
      reset_data
      journal.import_from_csv("entries.csv")
      journal.add_entry("English Breakfast", "Black", "Tea basket")
      entries = journal.iterative_search("English Breakfast")

      check_entry(entries.first, "English Breakfast", "Black", "Ceramic teapot")
      check_entry(entries.last, "English Breakfast", "Black", "Tea basket")
    end
  end

  describe "#write_to_csv" do

    it "writes to the data file" do
      reset_data

      new_entry = Entry.new('Gyokuro', 'Green', 'Kyusu')
      journal.write_to_csv(new_entry)

      new_numrows = CSV.readlines(journal.data_file).size

      expect(new_numrows).to eq(3)
    end

    it "writes the correct data to the data file" do
      reset_data

      new_entry = Entry.new('English Breakfast', 'Black', 'Ceramic teapot')
      journal.write_to_csv(new_entry)
      journal.load_data

      last_entry = journal.entries.last

      check_entry(last_entry, 'English Breakfast', 'Black', 'Ceramic teapot')
    end

  end

  describe "#delete_from_csv" do

    it "deletes one entry from the data file" do
      reset_data
      entry_to_delete = Entry.new('Sencha', 'Green', 'Kyusu')
      journal.delete_from_csv(entry_to_delete)
      new_numrows = CSV.readlines(journal.data_file).size

      expect(new_numrows).to eq(1)
    end

    it "deletes the correct data from the data file" do
      reset_data
      new_entry = Entry.new('Gyokuro', 'Green', 'Kyusu')
      journal.write_to_csv(new_entry)

      entry_to_delete = Entry.new('Sencha', 'Green', 'Kyusu')
      journal.delete_from_csv(entry_to_delete)
      csv_array = CSV.read(journal.data_file)

      expect(csv_array[1]).to eq(['Gyokuro', 'Green', 'Kyusu'])
    end

  end

  describe "#update_csv" do

    it "doesn't add data to the data file" do
      reset_data
      entry_to_edit = Entry.new('Sencha', 'Green', 'Kyusu')
      journal.update_csv(entry_to_edit, 'Gyokuro', 'Green', 'Kyusu')
      new_numrows = CSV.readlines(journal.data_file).size

      expect(new_numrows).to eq(2)
    end

    it "updates the correct data" do
      reset_data
      entry_to_edit = Entry.new('Sencha', 'Green', 'Kyusu')
      journal.update_csv(entry_to_edit, 'English Breakfast', 'Black', 'Ceramic teapot')

      csv_array = CSV.read(journal.data_file)
      expect(csv_array[1]).to eq(['English Breakfast', 'Black', 'Ceramic teapot'])
    end

    it "doesn't change values that are left blank" do
      reset_data
      entry_to_edit = Entry.new('Sencha', 'Green', 'Kyusu')
      journal.update_csv(entry_to_edit, '', '', 'Gaiwan')

      csv_array = CSV.read(journal.data_file)
      expect(csv_array[1]).to eq(['Sencha', 'Green', 'Gaiwan'])
    end
  end
end
