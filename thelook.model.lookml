# PRELIMINARIES # 

- connection: thelook
- scoping: true                          # for backward compatibility
- include: "*.lookml"


# BASE VIEWS #

- base_view: inventory_items
  joins:
    - join: products
      sql_foreign_key: inventory_items.product_id


- base_view: orders
  conditionally_filter:
    orders.created_date: 30 days 
    unless: [users.name, users.id]
  joins:
    - join: users
      sql_foreign_key: orders.user_id
      
    - join: users_orders_facts
      sql_foreign_key: users.id
      required_joins: [users]      
      

- base_view: order_items
  conditionally_filter:                     # prevent runaway queries
    orders.created_date: '30 days'          # by always requiring a filter 
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
      sql_foreign_key: order_items.inventory_item_id
      fields: inventory_items.export        # don't import all of the fields, just
                                            # the fields in this set.
    - join: orders
      sql_foreign_key: order_items.order_id

    - join: products
      sql_foreign_key: inventory_items.product_id
      required_joins: [inventory_items]
    
    - join: users
      sql_foreign_key: orders.user_id
      required_joins: [orders]
    
    - join: users_orders_facts
      sql_foreign_key: users.id
      required_joins: [users]
      
- base_view: products


- base_view: users
  joins:
  - join: users_orders_facts
    sql_foreign_key: users.id
    
  - join: users_sales_facts
    sql_foreign_key: users.id
    
  