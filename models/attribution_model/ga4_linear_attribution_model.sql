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
        path_length,
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
    'linear' as attribution_model,
    touchpoint_timestamp,
    IF(path_length=0,1,SAFE_DIVIDE(1,path_length)) as attributed_weight,
    utm_source,
    utm_medium,
    utm_campaign
FROM
    attribution_unnested


 