require_relative 'entry'
require 'csv'

class TeaJournal
  attr_reader :entries

  def initialize
    @entries = []
  end

  def add_entry(tea_name, type, brewing_method)
    entries << Entry.new(tea_name, type, brewing_method)
  end

  def remove_entry(tea_name, type, brewing_method)

    entries.each_with_index do |entry, index|
      if entry.tea_name == tea_name && entry.type == type && entry.brewing_method == brewing_method
        entries.delete(entry)
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
end
