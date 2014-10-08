# PRELIMINARIES #
- connection: thelook
- scoping: true                          # for backward compatibility
- include: "*.lookml"
- template: liquid

# EXPLORES #

- explore: inventory_items
  joins:
    - join: products
      foreign_key: inventory_items.product_id

- explore: orders
  conditionally_filter:
    orders.created_date: 30 days
    unless: [users.name, users.id]
  joins:
    - join: users
      foreign_key: orders.user_id

    - join: users_orders_facts
      foreign_key: users.id

- explore: order_items
  conditionally_filter:                     # prevent runaway queries
    orders.created_date: 30 days          # by always requiring a filter
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
      foreign_key: order_items.inventory_item_id
      fields: inventory_items.export        # don't import all of the fields, just
                                            # the fields in this set.
    - join: orders
      foreign_key: order_items.order_id

    - join: products
      foreign_key: inventory_items.product_id

    - join: users
      foreign_key: orders.user_id

    - join: users_orders_facts
      foreign_key: users.id

# - explore: order_purchase_affinity
#   joins: 
#     - join: product_a_detail
#       from: products
#       sql_on: order_purchase_affinity.product_a = product_a_detail.item_name
#     
#     - join: product_b_detail
#       from: products
#       sql_on: order_purchase_affinity.product_b = product_b_detail.item_name

#
# Declare how the tables are linked
#
- explore: funnel
  always_filter:
    event_time: 30 days ago for 30 days
  
  joins:
  - join: users
    foreign_key: user_id
  - join: orders
    foreign_key: order_id
    
    
- explore: products

- explore: users
  joins:
  - join: users_orders_facts
    foreign_key: users.id

  - join: users_revenue_facts
    foreign_key: users.id   
    join_type: one_to_one

  - join: users_sales_facts
    foreign_key: users.id

- explore: user_order_speed
  joins:
  - join: users
    foreign_key: user_order_speed.user_id
