- dashboard: the_look
  title: The Look
  elements:

    - name: orders_by_age_tier
      type: piechart
      title: Orders by Age Tier
      base_view: orders
      data: 
        group: users.age_tier
        measure: orders.count 