- dashboard: 1_business_pulse
  title: "1) Business Pulse"
  layout: tile
  tile_size: 100
  
  filters:
  
  - name: date
    title: "Date"
    type: date_filter
    default_value: Last 90 Days
    
  - name: state
    title: "State / Region"
    type: select_filter
    base_view: users
    dimension: users.state
    
  elements:
  
  - name: test_dashboard_tile
    title: Add a title
    type: line
    base_view: orders
    dimensions: [orders.created_date]
    measures: [orders.count, orders.average_order_profit]
    filters:
      orders.created_date: last 30 days
    limit: 500
    width: 12
    height: 4
    legend_align:
    hide_legend:
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
  
  
  
  - name: total_orders
    type: single_value
    base_view: orders
    measures: [orders.count]
    listen:
      date: orders.created_date
      state: users.state
    width: 4
    height: 2
    
  - name: average_order_profit
    type: single_value
    base_view: orders
    measures: [orders.average_order_profit]
    listen:
      date: orders.created_date
      state: users.state
    width: 4
    height: 2

  - name: first_purchasers
    type: single_value
    base_view: orders
    measures: [orders.first_purchase_count]
    listen:
      date: orders.created_date
      state: users.state
    width: 4
    height: 2
    
  - name: orders_by_day_and_category
    title: "Orders by Day and Category"
    type: looker_area
    base_view: order_items
    dimensions: [orders.created_date]
    pivots: [category.name]
    measures: [order_items.count]
    filters:
      category.name: Blazers & Jackets, Sweaters, Pants, Shorts, Fashion Hoodies & Sweatshirts, Accessories
    listen:
      date: orders.created_date
      state: users.state
    sorts: [orders.created_date]
    limit: 500
    width: 6
    colors: [lightskyblue, aqua, cornflowerblue, mediumblue, blue, navy]
    height: 4
    legend_align:
    y_axis_labels: "# Order Items"
    stacking: normal
    x_axis_datetime: yes
    hide_points: yes
    hide_legend: yes
    
  - name: sales_by_date
    title: "Sales by Date - Last 30 Days"
    type: looker_column
    base_view: order_items
    dimensions: [orders.created_date]
    measures: [order_items.total_sale_price]
    listen:
      state: users.state
    filters: 
      orders.created_date: last 30 days
    sorts: [orders.created_date desc]
    limit: 30
    width: 6
    height: 4
    legend_align:
    colors: [darkorange]
    reference_lines:
      - value: [max, mean]
        label: Above Average
        color: midnightblue
      - value: 20000
        label: Target
        color: black
      - value: [median]
        label: Median
        color: grey
    hide_legend:
    stacking:
    x_axis_label:
    x_axis_datetime: yes
    x_axis_datetime_label:
    x_axis_label_rotation:
    y_axis_orientation: 
    y_axis_labels: "Total Sale Price ($)"
    y_axis_combined: yes
    y_axis_min: 
    hide_legend: yes
    y_axis_max: 50000
    hide_points: yes

  - name: top_zips_map
    title: "Top Zip Codes"
    type: looker_geo_coordinates
    map: usa
    base_view: order_items
    dimensions: [users.zipcode]
    measures: [order_items.count]
    colors: [gold, orange, darkorange, orangered, red]
    listen:
      date: orders.created_date
      state: users.state
    point_color: yellow
    map_color: "#000061"
    width: 6
    point_radius: 3
    sorts: [order_items.count desc]
    height: 4
    limit: 500
    
  - name: sales_state_map
    title: "Sales by State"
    type: looker_geo_choropleth
    map: usa
    base_view: order_items
    dimensions: [users.state]
    measures: [order_items.count]
   # colors: [fff000, 000000] #gold, orange, darkorange, orangered, red]
#     colors: [red, white, blue, yellow]
    colors: [red, '#122f8c','#202e7e','#2e2d70','#3c2d63']
    sorts: [order_items.total_sale_price desc]
    listen:
      date: orders.created_date
      state: users.state
    width: 6
    height: 4
    limit: 500  
    
  - name: sales_by_date_and_category
    title: "Sales by Date and Category"
    type: looker_donut_multiples
    base_view: order_items
    dimensions: [orders.created_week]
    pivots: [category.name]
    measures: [order_items.count]
    filters:
      orders.created_date: 6 weeks ago for 6 weeks
      category.name: Accessories, Active, Blazers & Jackets, Clothing Sets
    sorts: [orders.created_week desc]
    colors: [yellow, orange, red, blue, purple]
    limit: 24
    width: 6
    height: 4
    charts_across: 3
  
    
  - name: top_10_brands
    title: "Top 10 Brands"
    type: table
    base_view: order_items
    dimensions: [brand.name]
    measures: [order_items.count, order_items.total_sale_price, order_items.average_sale_price]
    listen:
      date: orders.created_date
      state: users.state
    sorts: [order_items.count desc]
    limit: 15
    width: 6
    height: 4
    
  - name: layer_cake_cohort
    title: "Cohort - orders Layered by Sign Up Month"
    type: looker_area
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
    y_axis_labels: ["Number of orders"]
    x_axis_label: "Order Month"
    legend_align: right
    colors: [FF0000,DE0000,C90000,9C0202,800101,6B0000,4D006B,0D0080,080054,040029,000000]
    stacking: normal
    hide_points: yes
    
  - name: customer_cohort
    type: table
    base_view: orders
    dimensions: [orders.created_month]
    pivots: [users.created_month]
    measures: [users.count]
    filters:
      orders.created_month: 12 months ago for 12 months
      users.created_month: 12 months ago for 12 months
    sorts: [orders.created_month desc]
    limit: 500
    width: 12
    height:  
        
- dashboard: 2_brand_overview
  title: "2) Brand Overview"
  layout: tile
  tile_size: 100
  
  filters:
  
  - name: brand
    title: "Brand Name"
    type: select_filter
    base_view: products
    dimension: brand.name
    default_value: Calvin Klein
    
  - name: date
    title: "Date"
    type: date_filter
    default_value: Last 90 Days
    
  elements:
  
  - name: total_orders
    type: single_value
    base_view: order_items
    measures: [orders.count]
    listen:
      date: orders.created_date
      brand: brand.name
    width: 4
    height: 2
    
  - name: total_customers
    type: single_value
    base_view: order_items
    measures: [users.count]
    listen:
      date: orders.created_date
      brand: brand.name
    width: 4
    height: 2  
    
  - name: average_order_value
    type: single_value
    base_view: order_items
    measures: [order_items.average_sale_price]
    listen:
      date: orders.created_date
      brand: brand.name
    width: 4
    height: 2
    
  - name: sales_over_time
    title: "Sales, Last 90 Days"
    type: looker_line
    base_view: order_items
    dimensions: [orders.created_date]
    measures: [order_items.total_sale_price, order_items.average_sale_price]
    listen:
      brand: brand.name
    filters:
      orders.created_date: 90 days
    limit: 500
    width: 12
    height: 3
    legend_align:
    stacking:
    x_axis_label:
    x_axis_datetime: yes
    x_axis_datetime_label:
    x_axis_label_rotation:
    y_axis_orientation: [left,right]
    colors: [purple, gold]
    y_axis_combined:
    y_axis_labels: ["Total Sale Amount","Average Selling Price"]
    y_axis_min:
    y_axis_max:
    hide_points: yes
    hide_legend: yes
  
        
  - name: sales_by_department_and_category
    title: "Sales by Department and Category"
    type: table
    base_view: order_items
    dimensions: [category.name]
    pivots: [department.name]
    measures: [order_items.count, order_items.total_sale_price]
    listen:
      date: orders.created_date
      brand: brand.name
    sorts: [order_items.count desc]
    limit: 500
    width: 6
    height: 4
    
  - name: connoisseur
    title: "Top Purchasers of "
    type: table
    base_view: order_items
    dimensions: [users.name, users.email, users.history]
    measures: [order_items.count, order_items.total_sale_price]
    listen:
      date: orders.created_date
      brand: brand.name
    sorts: [order_items.count desc]
    limit: 15
    width: 6
    height: 4

- dashboard: 3_category_lookup
  title: "3) Category Lookup"
  layout: tile
  tile_size: 100
  
  filters:
  
  - name: category
    title: "Category Name"
    type: select_filter
    base_view: products
    dimension: category.name
    default_value: Jeans
    
  - name: department
    title: "Department"
    type: select_filter
    base_view: products
    dimension: department.name
    
  - name: date
    title: "Date"
    type: date_filter
    default_value: Last 90 Days
    
  elements:
  
  - name: total_orders
    type: single_value
    base_view: order_items
    measures: [orders.count]
    listen:
      category: category.name
      date: orders.created_date
      department: department.name
    width: 4
    height: 2  
    
  - name: total_customers
    type: single_value
    base_view: order_items
    measures: [users.count]
    listen:
      date: orders.created_date
      category: category.name
      department: department.name
    width: 4
    height: 2  
    
  - name: average_order_value
    type: single_value
    base_view: order_items
    measures: [order_items.average_sale_price]
    listen:
      date: orders.created_date
      category: category.name
      department: department.name
    width: 4
    height: 2
    
  - name: comparison
    title: "All Categories Comparison"
    type: table
    base_view: order_items
    dimensions: [category.name]
    measures: [order_items.average_sale_price, users.count, orders.count]
    listen:
      date: orders.created_date
      department: department.name
    sorts: [order_items.average_sale_price desc]
    width: 6
    height: 4
    limit: 50

  - name: sales_by_day
    title: "Sales by Date"
    type: looker_line
    base_view: order_items
    dimensions: [orders.created_date]
    measures: [order_items.average_sale_price, order_items.total_sale_price]
    listen:
      date: orders.created_date
      category: category.name
      department: department.name
    sorts: [orders.created_date]
    width: 6
    height: 4
    legend_align:
    stacking:
    x_axis_label:
    x_axis_datetime: yes
    x_axis_datetime_label:
    x_axis_label_rotation:
    y_axis_orientation: [left,right]
    y_axis_combined:
    y_axis_labels: ["Average Selling Price ($)","Total Sale Amount ($)"]
    y_axis_min:
    y_axis_max:
    hide_points: yes
    
  - name: demographic
    title: "Age Demographic"
    type: looker_column
    base_view: order_items
    dimensions: [users.age_tier]
    measures: [order_items.average_sale_price, order_items.count]
    listen:
      date: orders.created_date
      category: category.name
      department: department.name    
    sorts: [users.age_tier]
    limit: 500
    width: 6
    height: 4
    legend_align:
    stacking:
    x_axis_label: "Age Tier"
    x_axis_datetime: 
    x_axis_datetime_label:
    x_axis_label_rotation:
    y_axis_orientation: [left,right]
    y_axis_combined:
    y_axis_labels: ["Average Selling Price ($)","# orders"]
    y_axis_min:
    y_axis_max:
    
  - name: top_brands_within_category
    title: "Top Brands"
    type: table
    base_view: order_items
    dimensions: [brand.name]
    measures: [order_items.count, order_items.gross_margin_percentage, order_items.total_sale_price]
    listen:
      date: orders.created_date
      category: category.name
      department: department.name    
    sorts: [order_items.total_sale_price desc]
    limit: 25
    width: 6
    height: 4