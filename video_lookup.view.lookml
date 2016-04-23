- explore: video_lookup
- view: video_lookup


  derived_table:
    sql: |
      SELECT
        "Slack Your Data with the Lookerbot" as video_name
        , "https://www.dropbox.com/s/ubz3ib0vvrhbznc/alexa_meet_looker.mp4?dl=1" as video_url

  fields:
    - dimension: video_name
      sql: ${TABLE}.video_name

    - dimension: video_url
      sql: ${TABLE}.video_url

    - dimension: embedded_video
      sql: ${video_url}
      html: |
        <video width="600" height="400" controls>
        <source src="{{ value }}" type="video/mp4">
        </video>
    