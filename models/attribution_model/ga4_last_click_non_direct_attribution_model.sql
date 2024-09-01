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

),

last_click_non_direct_model_calc AS (
  
  SELECT
    order_surrogate_key,
    order_date,
    lookback_window,
    utm_source,
    utm_medium,
    utm_campaign,
    touchpoint_timestamp,
    IF(utm_source = '(direct)',TRUE,FALSE) AS is_direct_interaction,
    IF(utm_source = '(direct)',NULL,RANK() OVER (PARTITION BY order_surrogate_key,lookback_window ORDER BY touchpoint_timestamp DESC)) AS non_direct_ranking
  FROM
    attribution_unnested

)

SELECT
  order_surrogate_key,
  order_date,
  lookback_window,
  'last_click_non_direct' as attribution_model,
  touchpoint_timestamp,
  CASE
      WHEN MIN(non_direct_ranking) OVER (PARTITION BY order_surrogate_key,lookback_window) IS NULL AND ROW_NUMBER() OVER (PARTITION BY order_surrogate_key,lookback_window ORDER BY touchpoint_timestamp DESC) = 1 THEN 1 
      WHEN non_direct_ranking = MIN(non_direct_ranking) OVER (PARTITION BY order_surrogate_key,lookback_window) THEN 1
      ELSE 0
      END AS attributed_weight,
  utm_source,
  utm_medium,
  utm_campaign
FROM 
  last_click_non_direct_model_calc
