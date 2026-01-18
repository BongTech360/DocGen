# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample organizations
visa_org = Organization.find_or_create_by!(subdomain: 'visa-agency') do |org|
  org.name = 'Sample Visa Agency'
  org.organization_type = 'visa_agency'
end

bank_org = Organization.find_or_create_by!(subdomain: 'bank') do |org|
  org.name = 'Sample Bank'
  org.organization_type = 'bank'
end

university_org = Organization.find_or_create_by!(subdomain: 'university') do |org|
  org.name = 'Sample University'
  org.organization_type = 'university'
end

# Create sample users (only if they don't exist)
unless User.exists?(email: 'admin@visa-agency.com')
  User.create!(
    email: 'admin@visa-agency.com',
    password: 'password123',
    password_confirmation: 'password123',
    organization: visa_org
  )
end

unless User.exists?(email: 'admin@bank.com')
  User.create!(
    email: 'admin@bank.com',
    password: 'password123',
    password_confirmation: 'password123',
    organization: bank_org
  )
end

unless User.exists?(email: 'admin@university.com')
  User.create!(
    email: 'admin@university.com',
    password: 'password123',
    password_confirmation: 'password123',
    organization: university_org
  )
end

puts "Seeds completed successfully!"
puts "Sample users created:"
puts "  - admin@visa-agency.com / password123"
puts "  - admin@bank.com / password123"
puts "  - admin@university.com / password123"
