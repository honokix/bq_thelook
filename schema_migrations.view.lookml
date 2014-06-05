- view: schema_migrations
  fields:

  - dimension: filename
    sql: ${TABLE}.filename

  - measure: count
    type: count
    detail: detail*


  # ----- Detail ------
  sets:
    detail:
      - filename
