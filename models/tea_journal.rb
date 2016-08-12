require_relative 'entry'
require 'csv'

class TeaJournal
  attr_reader :entries, :data_file

  def initialize(data_file)
    @entries = []
    @data_file = data_file
  end

  def load_data
    csv_text = File.read(data_file)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    csv.each do |row|
      entries << Entry.new(row[0], row[1], row[2])
    end
  end

  def add_entry(tea_name, type, brewing_method)
    new_entry = Entry.new(tea_name, type, brewing_method)
    entries << new_entry
    write_to_csv(new_entry)
  end

  def remove_entry(tea_name, type, brewing_method)

    entries.each_with_index do |entry, index|
      if entry.tea_name == tea_name && entry.type == type && entry.brewing_method == brewing_method
        entries.delete(entry)
        delete_from_csv(entry)
      end
    end

  end

  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["tea_name"], row_hash["type"], row_hash["brewing_method"])
    end
  end

  def iterative_search(tea_name)
    results = []
    entries.each do |entry|
      results << entry if entry.tea_name == tea_name
    end
    results
  end

  def write_to_csv(entry)
    CSV.open(data_file, "a+") do |csv|
      csv << [entry.tea_name, entry.type, entry.brewing_method]
    end
  end

  def delete_from_csv(entry)
    csv_array = CSV.read(data_file)
    csv_array.each do |row|
      if row[0] == entry.tea_name && row[1] == entry.type && row[2] == entry.brewing_method
        csv_array.delete(row)
      end
    end

    CSV.open(data_file, 'w') do |csv|
      csv_array.each do |row|
        csv << row
      end
    end
  end
end
