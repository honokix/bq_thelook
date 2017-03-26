view: users {
  sql_table_name: users ;;
  # DIMENSIONS #

  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;

    link: {
      label: "View Order History"
      url: "/explore/thelook/orders?fields=orders.detail*&f[users.id]={{ value }}"
    }

    link: {
      label: "View Item History"
      url: "/explore/thelook/order_items?fields=order_items.detail*&f[users.id]={{ value }}"
    }
  }

  dimension: age {
    type: number
    # REPLACEME: users.age
    description: "foo word foo word foo word foo word foo word foo word foo word"
  }

  measure: average_age {
    type: average
    value_format_name: decimal_2
    sql: ${age} ;;
  }

  dimension: age_tier {
    type: tier
    style: integer
    sql: ${age} ;;
    tiers: [
      0,
      10,
      20,
      30,
      40,
      50,
      60,
      70,
      80
    ]
  }

  dimension: city {
    drill_fields: [zipcode]
  }

  dimension: state {
    drill_fields: [city, zipcode]
  }

  dimension: country {
    drill_fields: [state, city, zipcode]
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zip ;;
    alias: [zip]
    drill_fields: [gender, age_tier]
  }

  #   - dimension: country_first_letter
  #     type: string
  #     expression: substring(${country},0,1)

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    link: {
      url: "/dashboards/thelook/4_user_lookup?email={{ value | encode_uri }}"
      label: "User Lookup for {{ value }}"
    }
  }

  dimension: email_500 {
    sql: ${email} ;;
    suggest_dimension: email_500_suggest
  }

  dimension: email_500_suggest {
    sql: CASE
        WHEN ${email} like 'd%' THEN ${email}
        ELSE NULL
      END
       ;;
  }

  dimension: email_1000 {
    sql: ${email} ;;
    suggest_dimension: email_1000_suggest
  }

  dimension: email_1000_suggest {
    sql: CASE
        WHEN ${email} like 'z%' THEN ${email}
        WHEN ${email} like 'y%' THEN ${email}
        WHEN ${email} like 'w%' THEN ${email}
        WHEN ${email} like 'v%' THEN ${email}
        ELSE NULL
      END
       ;;
  }

  dimension: gender {}

  dimension: name {
    sql: CONCAT(${TABLE}.first_name,' ', ${TABLE}.last_name) ;;
  }

  filter: dimension_picker {
    suggestions: ["id", "age", "gender"]
  }

  dimension: dimension {
    sql: {% parameter dimension_picker %}
      ;;
  }

  #             {% capture name %}{% parameter dimension_picker %}{% endcapture %}
  #             {% assign normalized_name = name | replace: "'", "" | replace: "^", "" | strip %}
  #             {% assign valid_times = "id|age|gender" | split: "|" %}
  #             {% assign whitelisted = false %}
  #             {% for timeframe in valid_times %}
  #               {% if normalized_name == timeframe %}
  #                 {% assign whitelisted = true %}
  #               {% endif %}
  #             {% endfor %}
  #             {% if whitelisted %}{{normalized_name}}{% else %}BAD TIMEFRAME{% endif %}

  filter: measure_picker {
    suggestions: ["id", "age"]
  }

  filter: aggregation {
    suggestions: ["count", "sum", "average", "min", "max"]
  }

  #   - measure: measure
  #     type: number
  #     sql: |
  #             {% capture name %}{% parameter aggregation %}{% endcapture %}
  #             {% assign normalized_name = name | replace: "'", "" | replace: "^", "" | strip %}
  #             {% assign valid_times = "count|sum|average|min|max" | split: "|" %}
  #             {% assign whitelisted = false %}
  #             {% for timeframe in valid_times %}
  #               {% if normalized_name == timeframe %}
  #                 {% assign whitelisted = true %}
  #               {% endif %}
  #             {% endfor %}
  #             {% if whitelisted %}{{normalized_name}}{% else %}BAD TIMEFRAME{% endif %}(DISTINCT {% capture name %}{% parameter measure_picker %}{% endcapture %}
  #             {% assign normalized_name = name | replace: "'", "" | replace: "^", "" | strip %}
  #             {% assign valid_times = "id|age" | split: "|" %}
  #             {% assign whitelisted = false %}
  #             {% for timeframe in valid_times %}
  #               {% if normalized_name == timeframe %}
  #                 {% assign whitelisted = true %}
  #               {% endif %}
  #             {% endfor %}
  #             {% if whitelisted %}{{normalized_name}}{% else %}BAD TIMEFRAME{% endif %})
  #

  # MEASURES #

  measure: count {
    type: count_distinct
    sql: COALESCE(${id}, 0) ;;
    drill_fields: [detail*]
  }

  measure: count_percent_of_total {
    label: "Count (Percent of Total)"
    type: percent_of_total
    drill_fields: [detail*]
    value_format_name: decimal_1
    sql: ${count} ;;
  }

  # SETS #

  set: detail {
    fields: [
      id,
      name,
      email,
      city,
      state,
      country,
      zipcode,
      gender,
      age,

      #         # Counters for views that join 'users'
      orders.count,
      order_items.count
    ]
  }
}
