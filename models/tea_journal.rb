require_relative 'entry'

class TeaJournal
  attr_reader :entries

  def initialize
    @entries = []
  end

  def add_entry(tea_name, type, brewing_method)
    index = 0
    entries.each do |entry|
      if tea_name < entry.tea_name
        break
      end
      index += 1
    end

    entries.insert(index, Entry.new(tea_name, type, brewing_method))
  end

  def remove_entry(tea_name, type, brewing_method)

    entries.each_with_index do |entry, index|
      if entry.tea_name == tea_name && entry.type == type && entry.brewing_method == brewing_method
        entries.delete(entry)
      end
    end
    
  end
end
