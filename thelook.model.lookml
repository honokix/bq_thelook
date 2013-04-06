- scoping: true
- connection: demo_db

- include: events
- include: inventory_items
- include: orders
- include: order_items
- include: products
- include: schema_migrations
- include: users
- base_view: events
  view: events
  label: Events

- base_view: inventory_items
  view: inventory_items
  label: Inventory Items

- base_view: orders
  view: orders
  label: Orders

- base_view: order_items
  view: order_items
  label: Order Items

- base_view: products
  view: products
  label: Products

- base_view: schema_migrations
  view: schema_migrations
  label: Schema Migrations

- base_view: users
  view: users
  label: Users

# comment