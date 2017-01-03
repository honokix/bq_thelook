- explore: hebrew
- view: hebrew
  # Or, you could make this view a derived table, like this:
  derived_table:
    sql: |
      SELECT
        "גםכ" as one
        , "שהשפ" as two
        , "ההע" as three


  fields:
    - dimension: one
      label: "גםכ"
      sql: ${TABLE}.one

    - dimension: two
      label: "שהשפ"
      sql: ${TABLE}.two

    - dimension: three
      label: "ההע"
      sql: ${TABLE}.three

    - measure: count
      type: count
