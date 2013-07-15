- dashboard: sales_this_week
  title: Sales this Week
  layout: tile
  tile_size: 100
  elements:
  
  
      - name: top_5_categories
        type: column
        base_view: order_items
        dimension: category.name
        measures: [orders.count, order_items.count, orders.total_activation_count]
        filters:
          orders.created_date: 7 days
        limit: 5
        width: 8
        height: 4
        
      - name: total_orders
        type: single_value
        base_view: orders
        measure: [orders.count]
        filters:
          orders.created_date: 7 days
        width: 4
        height: 2
        
      - name: average_order_profit
        type: single_value
        base_view: orders
        measure: [orders.average_order_profit]
        filters:
          orders.created_date: 7 days
        width: 4
        height: 2
        
      - name: activations_as_%_of_total_orders
        type: pie
        base_view: orders
        group: [orders.is_activation]
        filters:
          orders.created_date: 7 days
        measure: orders.count
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
        dimension: orders.created_date
        measures: [orders.total_activation_revenue, orders.total_returning_shopper_revenue]
        filters:
          orders.created_date: 7 days
        sorts: orders.created_date
        width: 7
        height: 4
        xAxisLabelsRotation: -45
        stacking: normal
        
      - name: user_registrations
        type: line
        base_view: users
        dimension: users.created_date
        measures: [users.count]
        filters:
          users.created_date: 7 days
        sorts: users.created_date
        width: 5
        height: 4
        xAxisLabelsRotation: -45
        stacking: normal


      


#     - name: top_5_carriers_by_accidents
#       type: column
#       base_view: accidents
#       dimension: accidents.air_carrier
#       measures: [accidents.count, accidents.total_fatalities]
#       filters:
#         accidents.air_carrier: -EMPTY
#       limit: 6
#       width: 8
#       height: 4
# 
#     - name: number_of_flights_from_CA
#       type: single_value
#       base_view: flights
#       measure: flights.flight_number_count
#       filters:
#         origin.state: CA
#       width: 5
#       height: 2
#       
#     - name: total_number_of_accidents
#       type: single_value
#       base_view: accidents
#       measure: accidents.count
#       filters:
#         accidents.air_carrier: -EMPTY
#       width: 5
#       height: 2
#       
#     - name: flights_by_departure_hour
#       type: area
#       base_view: flights
#       dimension: flights.depart_hour
#       measures: [flights.count, flights.late_count, flights.verylate_count]
#       filters:
#         flights.depart_time: 2001-01-01 for 1 days
#       sorts: flights.depart_hour
#       width: 8
#       height: 4
#       xAxisLabelsRotation: -45
#       stacking: normal
# 
#     - name: flight_count_comparison_of_california_vs_new_york_vs_texas
#       type: pie
#       base_view: flights
#       group: origin.state
#       measure: flights.count
#       filters:
#         origin.state: CA,NY,TX
#       width: 5
#       height: 4
# 
# 
# 
# 
#       
# #     - name: total_fatalities
# #       type: single_value
# #       base_view: accidents
# #       measure: accidents.total_fatalities
# #       width: 5
# #       height: 2
# 
# # Not sure what this is. - NA
# #    - name: state
# #      type: lookup
# #      base_view: airports
# #      dimension: airports.state
# #      default: CA,NY
# #      height: 1
# #      width: 1
# 
# 
# #       
# #     - name: accidents_by_carrier_3
# #       type: scatter
# #       base_view: accidents
# #       dimension: accidents.air_carrier
# #       measures: [accidents.count]
# #       filters:
# #         accidents.air_carrier: -EMPTY
# #       limit: 6
# #       width: 6
# #       height: 4
# # 
# #     - name: flights_by_departure_hour_unstacked
# #       type: line
# #       base_view: flights
# #       dimension: flights.depart_hour
# #       measures: [flights.count, flights.late_count, flights.verylate_count]
# #       filters:
# #         flights.depart_time: 2001-01-01 for 1 days
# #       linked_filters:
# #         origin.state: state
# #       sorts: flights.depart_hour
# #       width: 6
# #       height: 4
# #       xAxisLabelsRotation: 45
# 
#       
# #     - name: flights_by_departure_hour_percent
# #       type: area
# #       base_view: flights
# #       dimension: flights.depart_hour
# #       measures: [flights.count, flights.late_count, flights.verylate_count]
# #       filters:
# #         flights.depart_time: 2001-01-01 for 1 days
# #       sorts: flights.depart_hour
# #       width: 6
# #       height: 4
# #       stacking: percent
# 
# #     - name: airports_by_elevation_tier
# #       type: pie
# #       base_view: airports
# #       group: airports.elevation_tier
# #       measure: airports.count
# #       sorts: airports.elevation_tier
# #       ugly_fish: hello
# #       width: 3
# #       height: 3
# # 
# #     - name: airports_by_control_tower
# #       type: pie
# #       base_view: airports
# #       group: airports.control_tower
# #       measure: airports.count
# #       width: 3
# #       height: 3
# # 
# 
# # 
# #     - name: flights_by_carrier
# #       type: pie
# #       base_view: flights
# #       group: carriers.name
# #       measure: flights.count
# #       width: 3
# #       height: 3
# # 
# #     - name: flights_by_origin
# #       type: pie
# #       base_view: flights
# #       group: origin.city
# #       measure: flights.count
# #       width: 3
# #       height: 3
# # 
#     - name: california_flights_by_california_destination
#       type: pie
#       base_view: flights
#       group: destination.city
#       measure: flights.count
#       filters:
#         origin.state: CA
#         destination.state: CA
#       width: 6
#       height: 5
#       
#     - name: flight_summary_stats
#       type: table
#       base_view: flights
#       dimensions: [flights.depart_hour]
#       measures: [flights.count, flights.late_count, flights.verylate_count]
#       width: 7
#       height: 5
# 