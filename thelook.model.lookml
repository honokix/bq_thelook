- scoping: true       # for backward compatibility

- connection: thelook
- include: thelook.includes

- base_view: inventory_items
  view: inventory_items
  label: Inventory Items
  joins:
    - join: products
      sql_on: inventory_items.product_id=products.id

- base_view: orders
  view: orders
  label: Orders
  joins:
    - join: users
      sql_on: orders.user_id=users.id


- base_view: order_items
  view: order_items
  label: Order Items
  conditionally_filter:                     # prevent runaway queries.
    orders.created_date: 1 month            # by always requiring a filter 
    unless:                                 # on one of the fields below.
      - orders.created_time
      - orders.created_week
      - orders.created_month
      - users.name
      - users.id
      - products.id
      - products.item_name
  joins:
    - join: inventory_items
      sql_on: order_items.inventory_item_id=inventory_items.id
      
    - join: orders
      sql_on: order_items.order_id=orders.id
      
    - join: products
      sql_on: inventory_items.product_id=products.id
      required_joins: [inventory_items]

    - join: users
      sql_on: orders.user_id=users.id
      required_joins: [orders]

    - join: users_orders_facts
      sql_on: users.id=users_orders_facts.user_id
      required_joins: [users]


- base_view: products
  view: products
  label: Products

- base_view: users
  view: users
  label: Users
  joins:
  - join: users_orders_facts
    sql_on: users.id=users_orders_facts.user_id

# - base_view: user_data
#   view: user_data
#   label: User Data
#   joins:
#     - join: users
#       sql_on: user_data.user_id=users.id

# - base_view: events
#   view: events
#   label: Events
#   joins:
#     - join: users
#       sql_on: events.user_id=users.id

# - base_view: schema_migrations
#   view: schema_migrations
#   label: Schema Migrations
