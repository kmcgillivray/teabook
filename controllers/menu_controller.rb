require_relative '../models/tea_journal'

class MenuController
  attr_reader :tea_journal

  def initialize
    @tea_journal = TeaJournal.new(DATA_FILE)
  end

  def main_menu
    puts "Main Menu — #{tea_journal.entries.count} entries"
    puts "1 – View all entries"
    puts "2 – Create an entry"
    puts "3 – Search for an entry"
    puts "4 – Import entries from a CSV"
    puts "5 – Exit"
    print "Enter your selection: "

    selection = gets.to_i

    case selection
      when 1
        system "clear"
        view_all_entries
        main_menu
      when 2
        system "clear"
        create_entry
        main_menu
      when 3
        system "clear"
        search_entries
        main_menu
      when 4
        system "clear"
        read_csv
        main_menu
      when 5
        puts "Goodbye!"
        exit(0)
      else
        system "clear"
        puts "Sorry, that is not a valid input"
        main_menu
    end
  end

  def view_all_entries
    tea_journal.entries.each do |entry|
      system "clear"
      puts entry.to_s
      puts "\n"
      entry_submenu(entry)
    end
    system "clear"
    puts "End of entries"
  end

  def create_entry
    system "clear"
    puts "New Teabook Entry"
    print "Tea name: "
    tea_name = gets.chomp
    print "Type: "
    type = gets.chomp
    print "Brewing method: "
    brewing_method = gets.chomp

    tea_journal.add_entry(tea_name, type, brewing_method)

    system "clear"
    puts "New entry created"
  end

  def search_entries
    print "Search by name: "
    tea_name = gets.chomp

    matches = tea_journal.iterative_search(tea_name)
    system "clear"

    if matches
      matches.each do |entry|
        system "clear"
        puts entry.to_s
        puts "\n"
        entry_submenu(entry)
      end
      system "clear"
      puts "End of entries"
    end
  end

  def read_csv
    print "Enter CSV file to import: "
    file_name = gets.chomp

    if file_name.empty?
      system "clear"
      puts "No CSV file read"
      main_menu
    end

    begin
      entry_count = tea_journal.import_from_csv(file_name).count
      system "clear"
      puts "#{entry_count} new entries added from #{file_name}"
    rescue
      puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
      read_csv
    end
  end

  def entry_submenu(entry)
    puts "n – next entry"
    puts "d – delete entry"
    puts "e – edit this entry"
    puts "m – return to main menu"

    selection = gets.chomp

    case selection

      when "n"
      when "d"
        system "clear"
        delete_entry(entry)
      when "e"
        edit_entry(entry)
        entry_submenu(entry)
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        entry_submenu(entry)
    end
  end

  def delete_entry(entry)
    tea_journal.remove_entry(entry.tea_name, entry.type, entry.brewing_method)
    puts "#{entry.tea_name} has been deleted"
    main_menu
  end

  def edit_entry(entry)
    print "Updated name: "
    tea_name = gets.chomp
    print "Updated type: "
    type = gets.chomp
    print "Updated brewing method: "
    brewing_method = gets.chomp

    entry.tea_name = tea_name if !tea_name.empty?
    entry.type = type if !type.empty?
    entry.brewing_method = brewing_method if !brewing_method.empty?
    system "clear"

    puts "Updated entry"
    puts entry
  end
end
