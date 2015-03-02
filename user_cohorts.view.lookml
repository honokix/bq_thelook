# This is an example of how to approach flexible cohort analysis in Looker.
# We aggregate transation facts by user-month and then also by cumulative
# user month, the result is a cohort analysis set to analyze in the Looker
# front-end, with the ability to slice and dice your users by any attribute

- view: user_transactions_monthly

  derived_table:
    sql: |
      SELECT users.user_id as user_id
        , month_list.month as month
        , COALESCE(monthly_transactions, 0) as monthly_transactions
        , COALESCE(monthly_revenue, 0) as monthly_revenue
      FROM (SELECT users.id as user_id, users.created_at as created_at FROM users) users
      LEFT JOIN (SELECT CONCAT(years.year, '-', months.month) as month
                FROM
                  (SELECT '2012' as year union SELECT '2013' union SELECT '2014' union SELECT '2015') years,
                  (SELECT '01' as month union SELECT '02' union SELECT '03' union SELECT '04'
                    union SELECT '05' union SELECT '06' union SELECT '07' union SELECT '08'
                    union SELECT '09' union SELECT '10' union SELECT '11' union SELECT '12') months
                ORDER BY 1) month_list
      ON LAST_DAY(STR_TO_DATE(CONCAT(month_list.month, "-1"), "%Y-%m-%d")) > users.created_at
      AND LAST_DAY(STR_TO_DATE(CONCAT(month_list.month, "-1"), "%Y-%m-%d")) < NOW()
      LEFT JOIN (SELECT 
                  o.user_id as user_id
                  , DATE_FORMAT(o.created_at, "%Y-%m") as trans_month
                  , COUNT(distinct o.id) AS monthly_transactions
                  , SUM(oi.sale_price) as monthly_revenue
                FROM order_items oi
                LEFT JOIN orders o ON oi.order_id = o.id
                GROUP BY 1,2) as data
          ON data.trans_month = month_list.month AND data.user_id = users.user_id
    indexes: [user_id, month]
    sql_trigger_value: SELECT CURRENT_DATE()

  fields:

  - dimension: user_id
    type: int
    primary_key: true
    sql: ${TABLE}.user_id

  - dimension: transaction
    type: time
    timeframes: [month]
    sql: STR_TO_DATE(CONCAT(${TABLE}.month, "-01"), "%Y-%m-%d")
    convert_tz: false
  
  - dimension: months_since_user_created
    type: number
    sql: |
      YEAR(STR_TO_DATE(CONCAT(${TABLE}.month, "-01"), "%Y-%m-%d"))*12
        + MONTH(STR_TO_DATE(CONCAT(${TABLE}.month, "-01"), "%Y-%m-%d"))
      - YEAR(${users_cohorts.created_date})*12
        - MONTH(${users_cohorts.created_date})

  - dimension: monthly_transactions
    type: number
    sql: ${TABLE}.monthly_transactions

  - dimension: monthly_revenue
    type: number
    sql: ${TABLE}.monthly_revenue

  - measure: sum_monthly_transactions
    type: sum
    sql: ${monthly_transactions}

  - measure: sum_monthly_revenue
    type: sum
    sql: ${monthly_revenue}
  
  - measure: average_monthly_transactions
    type: average
    decimals: 2
    sql: ${monthly_transactions}

  - measure: average_monthly_revenue
    type: average
    decimals: 2
    sql: ${monthly_revenue}

#####################################################################################

- view: user_transactions_monthly_cumulative
  derived_table:
    sql: |
      SELECT 
        utm1.user_id as user_id
        , utm1.month as month
        , SUM(COALESCE(utm2.monthly_transactions,0)) AS cumulative_monthly_transactions
        , SUM(COALESCE(utm2.monthly_revenue,0)) as cumulative_monthly_revenue
      FROM ${user_transactions_monthly.SQL_TABLE_NAME} as utm1
      LEFT JOIN ${user_transactions_monthly.SQL_TABLE_NAME} as utm2
      ON STR_TO_DATE(CONCAT(utm2.month, "-01"), "%Y-%m-%d") 
            <= STR_TO_DATE(CONCAT(utm1.month, "-01"), "%Y-%m-%d")
            AND utm1.user_id = utm2.user_id
      GROUP BY 1,2
      ORDER BY 1,2
    indexes: [user_id]
    sql_trigger_value: SELECT CURRENT_DATE()

  fields:
  
  - dimension: user_id
    type: int
    primary_key: true
    sql: ${TABLE}.user_id

  - dimension: transaction
    type: time
    timeframes: [month]
    sql: STR_TO_DATE(CONCAT(${TABLE}.month, "-01"), "%Y-%m-%d")
    convert_tz: false

  - dimension: months_since_user_created
    type: number
    sql: |
      YEAR(STR_TO_DATE(CONCAT(${TABLE}.month, "-01"), "%Y-%m-%d"))*12
        + MONTH(STR_TO_DATE(CONCAT(${TABLE}.month, "-01"), "%Y-%m-%d"))
      - YEAR(${users_cohorts.created_date})*12
        - MONTH(${users_cohorts.created_date})

  - dimension: cumulative_monthly_transactions
    type: number
    sql: ${TABLE}.cumulative_monthly_transactions

  - dimension: cumulative_monthly_revenue
    type: number
    sql: ${TABLE}.cumulative_monthly_revenue

  - measure: sum_cumulative_monthly_transactions
    type: sum
    sql: ${cumulative_monthly_transactions}

  - measure: sum_cumulative_monthly_revenue
    type: sum
    sql: ${cumulative_monthly_revenue}

  - measure: average_cumulative_monthly_transactions
    type: average
    decimals: 2
    sql: ${cumulative_monthly_transactions}

  - measure: average_cumulative_monthly_revenue
    type: average
    decimals: 2
    sql: ${cumulative_monthly_revenue}