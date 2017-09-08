label: "The Look"

connection: "thelook"

include: "*.view"
include: "*.dashboard"

explore: order_items {
  view_name: order_items

  join: orders {
    foreign_key: order_items.order_id
  }

  join: products {
    foreign_key: inventory_items.product_id
  }

  join: users {
    foreign_key: orders.user_id
  }

  join: users_orders_facts {
    foreign_key: users.id
  }

  join: inventory_items {
    foreign_key: order_items.inventory_item_id
  }
}

explore: inventory_items {
  join: products {
    foreign_key: inventory_items.product_id
  }
}

explore: orders {
  join: users {
    foreign_key: orders.user_id
  }

  join: users_orders_facts {
    foreign_key: users.id
  }
}

explore: funnel {
  always_filter: {
    filters: {
      field: event_time
      value: "30 days ago for 30 days"
    }
  }

  join: users {
    foreign_key: user_id
  }

  join: users_orders_facts {
    foreign_key: users.id
  }

  join: orders {
    foreign_key: order_id
  }
}

explore: products {}

explore: users {
  join: users_orders_facts {
    foreign_key: users.id
  }

  join: users_revenue_facts {
    foreign_key: users.id
    relationship: one_to_one
  }

  join: users_sales_facts {
    foreign_key: users.id
  }
}

explore: users_cohorts {
  from: users
  always_join: [user_transactions_monthly, user_transactions_monthly_cumulative]

  join: users_orders_facts {
    foreign_key: users_cohorts.id
  }

  join: users_revenue_facts {
    foreign_key: users_cohorts.id
    relationship: one_to_one
  }

  join: users_sales_facts {
    foreign_key: users_cohorts.id
  }

  join: user_transactions_monthly {
    sql_on: user_transactions_monthly.user_id = users_cohorts.id ;;
    relationship: many_to_one
  }

  join: user_transactions_monthly_cumulative {
    required_joins: [user_transactions_monthly]
    sql_on: user_transactions_monthly_cumulative.user_id = users_cohorts.id AND user_transactions_monthly_cumulative.month = user_transactions_monthly.month ;;
    relationship: many_to_one
  }
}
