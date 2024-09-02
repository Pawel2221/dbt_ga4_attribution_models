{{
    config(
        materialized= 'table',
        partition_by={
              "field": "order_timestamp",
              "data_type": "timestamp",
              "granularity": "day"
       }
    )
}}


WITH source AS (

    SELECT 
        touchpoint_date,
        touchpoint_timestamp,
        user_pseudo_id,
        session_id,
        utm_source,
        utm_medium,
        utm_campaign,
        order_timestamp,
        order_date
    FROM 
        {{ ref('ga4_source') }}

),

conv_path_struct AS (

    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'session_id',
            'order_timestamp'
        ]) }} as order_surrogate_key,
        order_date,
        order_timestamp,
        ARRAY_AGG(STRUCT(touchpoint_timestamp,
        utm_source,
        utm_medium,
        utm_campaign)) OVER (PARTITION BY user_pseudo_id ORDER BY touchpoint_timestamp) AS conv_path
    FROM
        source
        
    ),

lookback_windows AS (

    SELECT 
        order_surrogate_key,
        order_date,
        order_timestamp,
        touchpoint_timestamp,
        utm_source,
        utm_medium,
        utm_campaign,
        '30' AS lookback_window,
        COUNT(*) OVER (PARTITION BY order_surrogate_key) AS path_length
    FROM 
        conv_path_struct
    LEFT JOIN UNNEST(conv_path)
    WHERE TIMESTAMP_DIFF(order_timestamp, touchpoint_timestamp, DAY) <= 30

    UNION ALL

    SELECT 
        order_surrogate_key,
        order_date,
        order_timestamp,
        touchpoint_timestamp,
        utm_source,
        utm_medium,
        utm_campaign,
        '365' AS lookback_window,
        COUNT(*) OVER (PARTITION BY order_surrogate_key) AS path_length
    FROM conv_path_struct
    LEFT JOIN UNNEST(conv_path)
    WHERE TIMESTAMP_DIFF(order_timestamp, touchpoint_timestamp, DAY) <= 365

)

SELECT 
    order_surrogate_key,
    order_timestamp,
    order_date,
    lookback_window,
    path_length,
    ARRAY_AGG(STRUCT(
        touchpoint_timestamp,
        utm_source,
        utm_medium,
        utm_campaign
    )) AS conv_path
FROM lookback_windows
{{ dbt_utils.group_by(n=5) }}

