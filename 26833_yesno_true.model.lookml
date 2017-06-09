- connection: thelook
- explore: products
  hidden: true

- view: products
  fields:

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension: id_5
    type: yesno
    sql: ${id} >= 5
    
    
  - measure: id_5_count
    type: count
    filters:
      id_5: true