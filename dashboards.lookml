- dashboard: sales_this_week
  title: "Business Pulse"
  layout: tile
  tile_size: 100
  elements:
  
      - name: total_orders_last_30_days
        type: single_value
        base_view: orders
        measures: [orders.count]
        filters:
          orders.created_date: 30 days
        width: 4
        height: 2
        
      - name: average_order_profit_last_30_days
        type: single_value
        base_view: orders
        measures: [orders.average_order_profit]
        filters:
          orders.created_date: 30 days
        width: 4
        height: 2

      - name: first_purchasers_last_30_days
        type: single_value
        base_view: orders
        measures: [orders.first_purchase_count]
        filters:
          orders.created_date: 30 days
        width: 4
        height: 2
        
      - name: orders_by_day_and_category
        title: "Orders by Day and Category"
        type: area
        base_view: order_items
        dimensions: [orders.created_week]
        pivots: [category.name]
        measures: [order_items.count]
        filters:
          orders.created_date: 8 weeks
          category.name: Blazers & Jackets, Sweaters, Pants, Shorts, Fashion Hoodies & Sweatshirts, Accessories
        sorts: [orders.created_week]
        limit: 500
        width: 6
        height: 4
        legend_align:
        stacking: normal
        x_axis_datetime: yes
        
      - name: top_5_users_last_30_days
        title: "Top 10 Customers Last 30 Days"
        type: table
        base_view: order_items
        dimensions: [users.name]
        measures: [brand.list, order_items.count]
        filters:
          orders.created_date: 30 days
        sorts: [order_items.count desc]
        limit: 10
        width: 6
        height: 4
        
      - name: top_5_categories
        type: column
        base_view: order_items
        dimensions: category.name
        measures: [orders.count, order_items.count, orders.total_first_purchase_count]
        filters:
          orders.created_date: 7 days
        limit: 5
        width: 6
        height: 3
        y_axis_orientation: [left,right]
        y_axis_labels: ["# Orders","# Order Items"]
        
      - name: order_sequence_1_to_5
        title: "Orders by Sequence, 1 to 5"
        type: pie
        base_view: orders
        dimensions: [orders.order_sequence_number]
        filters:
          orders.created_date: 7 days
        limit: 5
        measures: orders.count
        width: 6
        height: 3
        
      - name: top_10_items
        type: table
        base_view: order_items
        dimensions: [products.item_name]
        measures: [order_items.total_sale_price, order_items.total_gross_margin]
        filters:
          orders.created_date: 14 days
        limit: 10
        sorts: order_items.total_sale_price desc
        width: 7
        height: 3

      - name: user_registrations
        type: line
        base_view: users
        dimensions: users.created_date
        measures: [users.count]
        filters:
          users.created_date: 10 weeks
        sorts: users.created_date
        width: 5
        height: 3
        x_axis_labels_rotation: -45
        x_axis_datetime: yes
        y_axis_labels: ["# Users"]
        stacking: normal  
        
      - name: cohort_thelook
        title: "Cohort - First Purchase Date by Sign Up Month"
        type: table
        base_view: orders
        dimensions: [users.created_month]
        pivots: [orders.created_month]
        measures: [orders.count_percent_of_total]
        filters:
          orders.created_month: 12 months
          users.created_month: 12 months
          orders.is_first_purchase: 'yes'
        sorts: [users.created_month]
        limit: 500
        width: 12
        height: 4
        
      - name: layer_cake_cohort
        title: "Cohort - Orders Layered by Sign Up Month"
        type: area
        base_view: orders
        dimensions: [orders.created_month]
        pivots: [users.created_month]
        measures: [orders.count]
        filters:
          orders.created_month: 12 months ago for 12 months
          users.created_month: 12 months ago for 12 months
        sorts: [orders.created_month]
        limit: 500
        width: 12
        height:
        legend_align:
        stacking: normal
        
- dashboard: static_sales_this_week
  title: Weekly Stats
  layout: static
  # 12 tiles wide
  width: 1200 
  tile_size: 100
  elements:
      - name: top_5_categories
        type: column
        base_view: order_items
        dimensions: category.name
        measures: [orders.count, order_items.count, orders.total_first_purchase_count]
        filters:
          orders.created_date: 7 days
        limit: 5
        width: 6
        height: 4
        # Static layout uses the `top` and `left` properties to position
        # individual dashboard elements.
        # top: 0 is the default, not set
        # left: 0 is the default, not set
        
      - name: total_orders
        type: single_value
        base_view: orders
        measures: [orders.count]
        filters:
          orders.created_date: 7 days
        width: 3
        height: 2
        # Set left: 6 here to position to the right of the previous chart.
        # left and top are both set in number of tiles, so we get 6 by 
        # taking the width of the previous chart.
        left: 6 
        
      - name: average_order_profit
        type: single_value
        base_view: orders
        measures: [orders.average_order_profit]
        filters:
          orders.created_date: 7 days
        width: 3
        height: 2
        # To position, right of the total_orders chart we add the width and left properties
        # together and that is our left value here.
        left: 9
        
        # Having this static layout allows for spanning in both right and left "columns" of the dashboard.
      - name: user_registrations
        type: line
        base_view: users
        dimensions: users.created_date
        measures: [users.count]
        filters:
          users.created_date: 7 days
        sorts: users.created_date
        width: 6
        height: 6
        top: 2
        left: 6
        x_axis_label_rotation: -45
        stacking: normal
        
        # Chart order in the yaml file is independent of their position on the dashboard.
        # In this case, activations_by_day appears underneath of top_5_categores and left of
        # user_registrations.
      - name: activations_by_day
        type: area
        base_view: orders
        dimensions: orders.created_date
        measures: [orders.total_first_purchase_revenue, orders.total_returning_shopper_revenue]
        filters:
          orders.created_date: 7 days
        sorts: orders.created_date
        width: 6
        height: 4
        top: 4
        x_axis_label_rotation: -45
        stacking: normal