# PRELIMINARIES #
- connection: thelook

################################################

- explore: explore_dt
  hidden: true
  joins:
  - join: inter_join_dt
    from: join_dt
    sql_on: ${inter_join_dt.id} = ${explore_dt.id}
    relationship: many_to_one

  - join: final_join_dt
    from: join_dt
    sql_on: ${final_join_dt.id} = ${inter_join_dt.id}
    relationship: one_to_one

- view: explore_dt
  derived_table:
    sql: |
      SELECT 1 as id
        , SUM(2) as sum

  fields: 
  - dimension: id
    primary_key: true
  - dimension: sum
  - measure: sum_sum
    type: sum
    sql: ${sum}

- view: join_dt
  derived_table:
    sql: |
      SELECT 1 as id
        , SUM(2) as sum
    persist_for: 5 minutes

  fields: 
  - dimension: id
    primary_key: true
  - dimension: sum
  - measure: sum_sum
    type: sum
    sql: ${sum}
    
################################################
