- view: user_data
  fields:

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail

  - dimension: has_ordered
    type: yesno

  - dimension: id
    type: int

  - dimension: one_order
    type: yesno

  - dimension: user_id
    type: int
    sets:
      - ignore


  # ----- Detail ------
  sets:
    detail:
      - id
      - users.last_name
      - users.first_name
      - users.id

