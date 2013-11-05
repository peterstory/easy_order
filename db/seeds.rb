# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

peter = User.create({name: 'Peter Story', email: 'peter.story@gordon.edu', 
                     password: 'wicked_insecure123', role: 'admin'})
craig = User.create({name: 'Craig Story', email: 'craig.story@gordon.edu',
                     password: 'master_password', role: 'user'})
bjork = User.create({name: 'Russell Bjork', email: 'Russell.Bjork@gordon.edu',
                     password: 'top_secret', role: 'user'})
miner = User.create({name: 'Simon Miner', email: 'simon.miner@gmail.com',
                     password: 'thebestpassword', role: 'user'})

friendships = Friendship.create([{user_id: peter.id, friend_id: craig.id},
                                 {user_id: craig.id, friend_id: peter.id},
                                 {user_id: craig.id, friend_id: bjork.id},
                                 {user_id: bjork.id, friend_id: miner.id},
                                 {user_id: miner.id, friend_id: bjork.id}
                                ])

b_zone = Restaurant.create({name: 'Burrito Zone', description: 'We serve decent burritos.',
                            cuisine: 'Mexican', street1: '404 Main Street', 
                            street2: 'Basement Room 5', city: 'Boston', state: 'MA', 
                            zipcode: '01993', phone: '978-123-4567', fax: '978-321-9876', 
                            url: 'www.burritozone.com', delivers: true, delivery_charge: 2.99, 
                            menu_file: 'C:\TOP_SECRET\Burrito.pdf'})
b_paradise = Restaurant.create({name: 'Burrito Paradise', description: 'The ULTIMATE burritos.',
                                cuisine: 'Mexican', street1: '101 Main Street', 
                                city: 'Boston', state: 'MA', 
                                zipcode: '01993', phone: '978-333-4567',
                                url: 'www.burritoparadise.com'})
p_palace = Restaurant.create({name: 'Pizza Palace', description: 'We have pizzas.',
                              cuisine: 'Italian', street1: '42 Canal Street', 
                              city: 'Salem', state: 'MA', 
                              zipcode: '01970', phone: '978-222-4567',
                              url: 'www.pizzapalace.com'})

b_zone_order = Order.create({restaurant_id: b_zone.id, organizer_id: peter.id, 
                             type: 'delivery', total: 14.20, status: 'pending', 
                             placed_at: (DateTime.now + 1)})
b_paradise_order = Order.create({restaurant_id: b_paradise.id, organizer_id: peter.id, 
                                 type: 'pick-up', total: 42.60, status: 'pending', 
                                 placed_at: (DateTime.now + 8)})
p_palace_order = Order.create({restaurant_id: p_palace.id, organizer_id: bjork.id, 
                               type: 'delivery', total: 24.03, status: 'placed', 
                               placed_at: (DateTime.now)})

participants = Participant.create([{user_id: peter.id, order_id: b_zone_order.id, 
                                    role: 'organizer', total: 14.20}, 
                                   {user_id: peter.id, order_id: b_paradise_order.id, 
                                    role: 'organizer', total: 20.05}, 
                                   {user_id: craig.id, order_id: b_paradise_order.id, 
                                    role: 'participant', total: 22.55}, 
                                   {user_id: bjork.id, order_id: p_palace_order.id, 
                                    role: 'organizer', total: 24.03}
                                  ])
