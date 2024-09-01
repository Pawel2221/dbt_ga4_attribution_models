{{
    config(
        materialized = 'incremental',
        partition_by={
              "field": "event_date_dt",
              "data_type": "date",
              "granularity": "day"
       }
    )
}}

SELECT 
    {{ ga4_select() }} 
FROM  {{ source('ga4', 'events') }}

  {% if is_incremental() %}
WHERE DATE(TIMESTAMP_MICROS(event_timestamp)) = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
  {% endif %}