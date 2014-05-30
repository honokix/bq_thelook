- view: users
  fields:

# DIMENSIONS #

  - dimension: id
    type: int
    primary_key: true
    sql: ${TABLE}.id

  - dimension: age
    type: int

  - dimension: age_tier
    type: tier
    sql: ${age}
    tiers: [0,10,20,30,40,50,60,70,80]

  - dimension: city

  - dimension: country

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.created_at

  - dimension: email

  - dimension: gender
  
  - dimension: name
    sql: CONCAT(${TABLE}.first_name,' ', ${TABLE}.last_name)

  - dimension: history
    sql: ${TABLE}.id
    html: |
      <a href=/explore/thelook/orders?fields=orders.detail*&f[users.id]=<%= value %>>orders</a>
      | <a href=/explore/thelook/order_items?fields=order_items.detail*&f[users.id]=<%= value %>>Items</a>

  - dimension: state

  - dimension: zip
    type: int
    
  - dimension: zipcode
    type: zipcode
    hidden: true
    sql: ${zip}
    
# MEASURES #

  - measure: count
    type: count
    detail: detail

  - measure: count_percent_of_total
    label: Count (Percent of Total)
    type: percent_of_total
    detail: detail*
    decimals: 1
    sql: ${count}

# SETS #

  sets:
    detail:
      - id
      - name
      - email
      - city
      - state
      - country
      - zip
      - gender
      - age
      - history
        # Counters for views that join 'users'
      - orders.count
      - order_items.count