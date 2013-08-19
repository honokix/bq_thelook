- dashboard: sales_this_week
  title: Sales this Week
  layout: tile
  tile_size: 100
  elements:
  
      - name: top_5_categories
        type: column
        base_view: order_items
        dimensions: category.name
        measures: [orders.count, order_items.count, orders.total_activation_count]
        filters:
          orders.created_date: 7 days
        limit: 5
        width: 8
        height: 4
        
      - name: total_orders
        type: single_value
        base_view: orders
        measures: [orders.count]
        filters:
          orders.created_date: 7 days
        width: 4
        height: 2
        
      - name: average_order_profit
        type: single_value
        base_view: orders
        measures: [orders.average_order_profit]
        filters:
          orders.created_date: 7 days
        width: 4
        height: 2
        
      - name: activations_as_%_of_total_orders
        type: pie
        base_view: orders
        dimensions: [orders.is_activation]
        filters:
          orders.created_date: 7 days
        measures: orders.count
        width: 4
        height: 4
          
      - name: top_10_items
        type: table
        base_view: order_items
        dimensions: [products.item_name]
        measures: [order_items.total_sale_price, order_items.total_gross_margin]
        filters:
          orders.created_date: 14 days
        limit: 10
        sorts: order_items.total_sale_price desc
        width: 8
        height: 4

      - name: activations_by_day
        type: area
        base_view: orders
        dimensions: orders.created_date
        measures: [orders.total_activation_revenue, orders.total_returning_shopper_revenue]
        filters:
          orders.created_date: 7 days
        sorts: orders.created_date
        width: 7
        height: 4
        x_axis_labels_rotation: -45
        stacking: normal
        
      - name: user_registrations
        type: line
        base_view: users
        dimensions: users.created_date
        measures: [users.count]
        filters:
          users.created_date: 7 days
        sorts: users.created_date
        width: 5
        height: 4
        x_axis_labels_rotation: -45
        stacking: normal

#- dashboard: static_sales_this_week
#  title: Static Layout - Sales this Week
#  layout: static
#  # 12 tiles wide
#  width: 1200 
#  tile_size: 100
#  elements:
#      - name: top_5_categories
#        type: column
#        base_view: order_items
#        dimensions: category.name
#        measures: [orders.count, order_items.count, orders.total_activation_count]
#        filters:
#          orders.created_date: 7 days
#        limit: 5
#        width: 6
#        height: 4
#        # Static layout uses the `top` and `left` properties to position
#        # individual dashboard elements.
#        # top: 0 is the default, not set
#        # left: 0 is the default, not set
#        
#      - name: total_orders
#        type: single_value
#        base_view: orders
#        measures: [orders.count]
#        filters:
#          orders.created_date: 7 days
#        width: 3
#        height: 2
#        # Set left: 6 here to position to the right of the previous chart.
#        # left and top are both set in number of tiles, so we get 6 by 
#        # taking the width of the previous chart.
#        left: 6 
#        
#      - name: average_order_profit
#        type: single_value
#        base_view: orders
#        measures: [orders.average_order_profit]
#        filters:
#          orders.created_date: 7 days
#        width: 3
#        height: 2
#        # To position, right of the total_orders chart we add the width and left properties
#        # together and that is our left value here.
#        left: 9
#        
#        # Having this static layout allows for spanning in both right and left "columns" of the dashboard.
#      - name: user_registrations
#        type: line
#        base_view: users
#        dimensions: users.created_date
#        measures: [users.count]
#        filters:
#          users.created_date: 7 days
#        sorts: users.created_date
#        width: 6
#        height: 6
#        top: 2
#        left: 6
#        x_axis_label_rotation: -45
#        stacking: normal
#        
#        # Chart order in the yaml file is independent of their position on the dashboard.
#        # In this case, activations_by_day appears underneath of top_5_categores and left of
#        # user_registrations.
#      - name: activations_by_day
#        type: area
#        base_view: orders
#        dimensions: orders.created_date
#        measures: [orders.total_activation_revenue, orders.total_returning_shopper_revenue]
#        filters:
#          orders.created_date: 7 days
#        sorts: orders.created_date
#        width: 6
#        height: 4
#        top: 4
#        x_axis_label_rotation: -45
#        stacking: normal
#        
