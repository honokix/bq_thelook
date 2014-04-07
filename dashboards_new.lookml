- dashboard: dashboard_new
  title: New Dashboard
  layout: tile
  tile_size: 100
  elements:
  
  - name: orders_by_date
    title: "Orders by Date"
    type: line
    base_view: orders
    dimensions: [orders.created_date]
    measures: [orders.count]
    limit: 500
    width:
    height:
    legend_align:
    stacking:
    x_axis_label:
    x_axis_datetime:
    x_axis_datetime_label:
    x_axis_label_rotation:
    y_axis_orientation:
    y_axis_combined:
    y_axis_labels:
    y_axis_min:
    y_axis_max:
    hide_points:
