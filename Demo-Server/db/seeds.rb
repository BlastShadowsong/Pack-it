# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.find_or_initialize_by(role: :admin, email: ENV['ADMIN_EMAIL'].dup)
admin.password = ENV['ADMIN_PASSWORD'].dup
admin.save!
puts 'DEFAULT ADMIN: ' << admin.email
