require_relative 'controllers/menu_controller'

menu = MenuController.new
system "clear"
puts "Welcome to Teabook!"

menu.main_menu
