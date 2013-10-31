- view: user_data
  fields:

# DIMENSIONS #

  - dimension: has_ordered
    type: yesno

  - dimension: id
    type: int

  - dimension: one_order
    type: yesno

  - dimension: user_id
    type: int
    hidden: true

# MEASURES #

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail

# SETS #

  sets:
    detail:
      - id
      - users.last_name
      - users.first_name
      - users.id