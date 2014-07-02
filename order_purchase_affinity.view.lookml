- view: order_product
  derived_table: 
    persist_for: 24 hours
    indexes: [order_id]
    sql: |
      SELECT o.id as order_id
      , oi.inventory_item_id as inventory_item_id
      , p.item_name as product
      FROM order_items oi
      JOIN orders o ON o.id = oi.order_id
      JOIN inventory_items ii ON oi.inventory_item_id = ii.id
      JOIN products p ON ii.product_id = p.id
      GROUP BY order_id, item_name

- view: total_order_product
  derived_table: 
    persist_for: 24 hours
    indexes: [product]
    sql: |
      SELECT p.item_name as product
      , count(distinct p.item_name, o.id) as product_frequency
      FROM order_items oi
      JOIN orders o ON o.id = oi.order_id
      JOIN inventory_items ii ON oi.inventory_item_id = ii.id
      JOIN products p ON ii.product_id = p.id
      GROUP BY p.item_name

- view: order_purchase_affinity
  derived_table: 
    persist_for: 24 hours
    indexes: [product_a]
    sql: |
      SELECT product_a
      , product_b
      , joint_frequency
      , top1.product_frequency as product_a_frequency
      , top2.product_frequency as product_b_frequency
      FROM (
        SELECT op1.product as product_a
        , op2.product as product_b
        , count(*) as joint_frequency
        FROM ${order_product.SQL_TABLE_NAME} as op1
        JOIN ${order_product.SQL_TABLE_NAME} op2 ON op1.order_id = op2.order_id
        GROUP BY product_a, product_b 
      ) as prop
      JOIN ${total_order_product.SQL_TABLE_NAME} as top1 ON prop.product_a = top1.product
      JOIN ${total_order_product.SQL_TABLE_NAME} as top2 ON prop.product_b = top2.product
      ORDER BY product_a, joint_frequency DESC, product_b

  fields:
  - dimension: product_a
    sql: ${TABLE}.product_a

  - dimension: product_b
    sql: ${TABLE}.product_b

  - dimension: joint_frequency
    type: number
    sql: ${TABLE}.joint_frequency

  - dimension: product_a_frequency
    type: number
    sql: ${TABLE}.product_a_frequency

  - dimension: product_b_frequency
    type: number
    sql: ${TABLE}.product_b_frequency
    
  - measure: affinity
    type: number
    decimals: 1
    sql: ${joint_frequency}/(${product_a_frequency}+${product_b_frequency}-${joint_frequency})*100