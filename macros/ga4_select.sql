{% macro ga4_select() %}

  DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date_dt,
  event_timestamp,
  event_name,
  user_pseudo_id,
  COALESCE(CONCAT(user_pseudo_id, {{ ga4_unnest_key('event_params', 'ga_session_id', 'int_value') }}), user_pseudo_id) AS session_id,
  CASE
      WHEN event_name = 'sign_up_completed' THEN event_timestamp
      ELSE NULL
  END AS is_with_order,
  {{ ga4_unnest_key('event_params', 'page_location', 'string_value') }} AS page_location,
  {{ ga4_unnest_key('event_params', 'page_referrer', 'string_value') }} AS page_referrer,
  {{ ga4_unnest_key('event_params', 'source', 'string_value') }} AS source_param
  
{% endmacro %}
