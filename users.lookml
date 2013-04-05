- view: users
  fields:

  - name: count
    type: count_distinct
    sql: $$.id
    detail: detail

  - name: zip
    type: int

  - name: country

  - name: state

  - name: city

  - name: created
    type: time
    timeframes: [time, date, week, month]
    sql: $$.created_at

  - name: gender

  - name: last_name

  - name: first_name

  - name: email

  - name: id
    type: int

  - name: age
    type: int
    
  - name: lifetime_number_of_orders
    type: int
    sql: |
      (SELECT COUNT(orders.id) FROM orders WHERE orders.user_id = users.id)
  
  - name: lifetime_number_of_orders_tier
    type: tier
    sql: ${lifetime_number_of_orders}
    tiers: [0,1,3,5,10]
    
  - name: age_tier
    type: tier
    sql: ${age}
    tiers: [15,19,26,33]

  # ----- Detail ------
  sets:
    detail: [
        last_name,
        first_name,
        id,
        # Counters for views that join 'users'
        events.count,
        orders.count,
    ]

