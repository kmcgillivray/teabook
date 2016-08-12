require_relative 'controllers/menu_controller'

DATA_FILE = 'data.csv'

menu = MenuController.new
system "clear"
puts "Welcome to Teabook!"

menu.tea_journal.load_data
menu.main_menu
