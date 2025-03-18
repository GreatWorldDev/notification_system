# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create test users
users = [
  { email: 'brettold.it@gmail.com', phone_number: '+14155552671' },
  { email: 'you@example.com', phone_number: '+14155552672' },
  { email: 'me@example.com', phone_number: '+14155552673' }
]

created_users = users.map do |user_data|
  user = User.create!(user_data)
  puts "Created user: #{user.email}"
  user
end

# Create devices for users
created_users.each do |user|
  2.times do |i|
    user.devices.create!(
      device_token: "device_token_#{user.id}_#{i}"
    )
    puts "Created device for user: #{user.email}"
  end
end

# Create groups
groups = [
  { name: 'Admins' },
  { name: 'VIPs' },
  { name: 'Premium Users' }
]

created_groups = groups.map do |group_data|
  group = Group.create!(group_data)
  puts "Created group: #{group.name}"
  group
end

# Add users to groups
created_groups[0].users << created_users[0]
created_groups[1].users << [ created_users[0], created_users[1] ]
created_groups[2].users << [ created_users[1], created_users[2] ]

puts "Added users to groups"

puts "Seed completed successfully!"
