puts "Welcome to Teabook!"

salutation = ARGV.first

ARGV.each do |arg|
  puts "#{salutation} #{arg}" unless arg == salutation
end
