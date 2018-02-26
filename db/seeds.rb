# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

seller1 = User.create(email: 'seller1@test.com', password: 'tester')
seller2 = User.create(email: 'seller2@test.com', password: 'tester')
buyer1 = User.create(email: 'buyer1@test.com', password: 'tester')
buyer2 = User.create(email: 'buyer2@test.com', password: 'tester')

Profile.create([
  {user: seller1, seller: true, name: 'Jane Doe', business_name: 'Dizzy D Farms', payable_to: 'Dizzy D Farms', phone_number: '0000000000', terms_of_service: true, registered: true, minimum_order: '25'},
  {user: seller2, seller: true, name: 'John Steaker', business_name: 'Ground Chuck Meat Co.', payable_to: 'John Steaker', phone_number: '0000000000', terms_of_service: true, registered: true, minimum_order: '50'},
  {user: buyer1, seller: false, name: 'Buyer1', phone_number: '1111111111', terms_of_service: true, registered: true},
  {user: buyer2, seller: false, name: 'Buyer2', phone_number: '1111111111', terms_of_service: true, registered: true}
])

Post.create([
  {user: seller1, title: 'Limes', description: 'Small green citrus fruit', price: '.50', unit: 'each', max_avaliable: 5},
  {user: seller1, title: 'Sweet Potatoes', description: 'Not yams, their white inside', price: '.79', unit: 'each', max_avaliable: 7},
  {user: seller1, title: 'Carrots', description: 'Orange tubers', price: '1.25', unit: 'per sack', max_avaliable: 3 },
  {user: seller2, title: 'Ground Beef', description: '100% Vegan', price: '2.99', unit: 'per pound', max_avaliable: 5},
  {user: seller2, title: 'Lamb Chops', description: 'Bone in, thick cut', price: '1.79', unit: 'per pound', max_avaliable: 4}
])
