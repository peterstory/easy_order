# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create([{name: 'Peter Story', email: 'peter.story@gordon.edu', 
                      password: 'wicked_insecure123', role: 'admin'}, 
                     {name: 'Craig Story', email: 'craig.story@gordon.edu',
                      password: 'master_password', role: 'user'}, 
                     {name: 'Russell Bjork', email: 'Russell.Bjork@gordon.edu',
                      password: 'top_secret', role: 'user'}, 
                     {name: 'Simon Miner', email: 'simon.miner@gmail.com',
                       password: 'thebestpassword', role: 'user'}, 
                     ])

friendships = Friendship.create([{user_id: (User.find_by name: 'Peter Story').id, 
                                  friend_id: (User.find_by name: 'Craig Story').id},
                                 {user_id: (User.find_by name: 'Craig Story').id, 
                                  friend_id: (User.find_by name: 'Peter Story').id},
                                 {user_id: (User.find_by name: 'Russell Bjork').id, 
                                  friend_id: (User.find_by name: 'Simon Miner').id},
                                 {user_id: (User.find_by name: 'Craig Story').id, 
                                  friend_id: (User.find_by name: 'Russell Bjork').id},
                                 {user_id: (User.find_by name: 'Simon Miner').id, 
                                  friend_id: (User.find_by name: 'Russell Bjork').id}
                                 ])

restaurants = Restaurant.create([{name: 'Burrito Zone', description: 'We serve decent burritos.',
                                  cuisine: 'Mexican', street1: '404 Main Street', 
                                  street2: 'Basement Room 5', city: 'Boston', state: 'MA', 
                                  zipcode: '01993', phone: '978-123-4567', fax: '978-321-9876', 
                                  url: 'www.burritozone.com', delivers: true, delivery_charge: 2.99, 
                                  menu_file: 'C:\TOP_SECRET\Burrito.pdf'}, 
                                 {name: 'Burrito Paradise', description: 'The ULTIMATE burritos.',
                                  cuisine: 'Mexican', street1: '101 Main Street', 
                                  city: 'Boston', state: 'MA', 
                                  zipcode: '01993', phone: '978-333-4567',
                                  url: 'www.burritoparadise.com'}, 
                                 {name: 'Pizza Palace', description: 'We have pizzas.',
                                   cuisine: 'Pizza', street1: '42 Canal Street', 
                                   city: 'Salem', state: 'MA', 
                                   zipcode: '01970', phone: '978-222-4567',
                                   url: 'www.pizzapalace.com'}
                                ])
