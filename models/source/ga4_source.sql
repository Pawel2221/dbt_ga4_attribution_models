-- Model represents sessionized data (touchpoints) with order details, traffic sources of the session, and details of the first page viewed in the session.

{{
    config(
        materialized = 'table',
        partition_by={
              "field": "touchpoint_date",
              "data_type": "date",
              "granularity": "day"
       }
    )
}}

WITH staging AS (

    SELECT 
        *,
        REGEXP_EXTRACT(page_location, r'utm_source=([^&]+)') AS encoded_utm_source,
        REGEXP_EXTRACT(page_location, r'utm_medium=([^&]+)') AS encoded_utm_medium,
        REGEXP_EXTRACT(page_location, r'utm_campaign=([^&]+)') AS encoded_utm_campaign,
        REGEXP_EXTRACT(page_location, r'gclid=([^&]+)') AS encoded_gclid
    FROM 
        {{ ref('ga4_staging') }}

),

utm as (

    SELECT 
        event_date_dt,
        user_pseudo_id,
        session_id, 
        event_name, 
        event_timestamp,
        page_location,
        page_referrer,
        {{ ga4_utm_mapping() }} 
    FROM
        staging
    WHERE event_name IN ('page_view', 'user_engagement')
    
    ),

utm_final AS (

    SELECT
        DATE(TIMESTAMP_MICROS(event_timestamp)) AS touchpoint_date,
        TIMESTAMP_MICROS(event_timestamp) AS touchpoint_timestamp,
        user_pseudo_id,
        session_id,
        utm_source,
        IF(utm_source = '(direct)', '(none)', utm_medium) AS utm_medium,
        utm_campaign,
        page_location,
        page_referrer
    FROM
        utm
    QUALIFY ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY event_timestamp) = 1
    
    ),

order_time AS (

    SELECT
        user_pseudo_id,
        session_id,
        MIN(TIMESTAMP_MICROS(is_with_order)) AS order_timestamp,
        MIN(DATE(TIMESTAMP_MICROS(is_with_order))) AS order_date,
        ARRAY_AGG(STRUCT(event_name, 
            TIMESTAMP_MICROS(event_timestamp) AS event_timestamp)) AS events
    FROM
        staging
    {{ dbt_utils.group_by(n=2) }}
    
    )

SELECT 
    touchpoint_date,
    touchpoint_timestamp,
    user_pseudo_id,
    session_id,
    utm_source,
    utm_medium,
    utm_campaign,
    order_timestamp,
    order_date,
    page_referrer,
    page_location,
    events
FROM utm_final
LEFT JOIN order_time USING (user_pseudo_id, session_id)






