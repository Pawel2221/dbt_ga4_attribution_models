{{
    config(
        materialized= 'table',
        partition_by={
              "field": "order_date",
              "data_type": "date",
              "granularity": "day"
       },
        cluster_by = ["attribution_model","lookback_window"]
    )
}}

WITH attribution_unnested AS (

    SELECT  
        order_surrogate_key,
        order_date,
        lookback_window,
        touchpoint_timestamp,
        utm_source,
        utm_medium,
        utm_campaign
    FROM 
        {{ ref('ga4_conv_paths_to_order_transformed') }}
    LEFT JOIN UNNEST (conv_path)

)

SELECT
    order_surrogate_key,
    order_date,
    lookback_window,
    'first_click' AS attribution_model,
    touchpoint_timestamp,
     (CASE
      WHEN ROW_NUMBER() OVER (PARTITION BY order_surrogate_key, lookback_window ORDER BY touchpoint_timestamp ASC) = 1 THEN 1
      ELSE 0
      END 
    ) AS attributed_weight,
    utm_source,
    utm_medium,
    utm_campaign
FROM
    attribution_unnested