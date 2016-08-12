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
    write_to_csv(data_file, new_entry)
  end

  # def remove_entry(tea_name, type, brewing_method)
  #
  #   entries.each_with_index do |entry, index|
  #     if entry.tea_name == tea_name && entry.type == type && entry.brewing_method == brewing_method
  #       entries.delete(entry)
  #     end
  #   end
  #
  # end
  #
  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["tea_name"], row_hash["type"], row_hash["brewing_method"])
    end
  end

  def write_to_csv(file_name, entry)
    CSV.open(file_name, "a+") do |csv|
      csv << [entry.tea_name, entry.type, entry.brewing_method]
    end
  end
end
