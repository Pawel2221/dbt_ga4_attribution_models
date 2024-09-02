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

{% set attribution_models = [
    'ga4_first_click_attribution_model',
    'ga4_last_click_non_direct_attribution_model',
    'ga4_linear_attribution_model'
] %}

{% for model in attribution_models %}
    SELECT * FROM {{ ref(model) }}
    {% if not loop.last %} UNION ALL {% endif %}
{% endfor %}
