- view: products
  fields:

  - name: count
    type: count_distinct
    sql: $$.id
    detail: detail

  - name: sku

  - name: rank
    type: int

  - name: department

  - name: retail_price
    type: number
    decimals: 2

  - name: brand

  - name: item_name

  - name: category

  - name: id
    type: int


  # ----- Detail ------
  sets:
    detail: [
        item_name,
        id,
        # Counters for views that join 'products'
        inventory_items.count,
    ]

