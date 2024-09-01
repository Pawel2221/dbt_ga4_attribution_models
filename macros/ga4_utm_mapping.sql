{%- macro ga4_utm_mapping() -%}

    CASE 
        WHEN encoded_utm_source IS NOT NULL THEN encoded_utm_source 
        WHEN encoded_utm_source IS NULL AND source_param IS NULL AND encoded_gclid IS NOT NULL THEN 'google'
        WHEN encoded_utm_source IS NULL AND source_param IS NOT NULL THEN source_param
        WHEN page_referrer LIKE '%brand_name%' THEN 'brand_name'
    ELSE '(direct)' END AS utm_source,
    CASE
        WHEN encoded_utm_medium IS NOT NULL THEN encoded_utm_medium
        WHEN encoded_utm_medium IS NULL AND encoded_gclid IS NOT NULL THEN 'cpc'
        WHEN encoded_utm_medium IS NULL AND (source_param IN ('google', 'bing') OR encoded_utm_source IN ('google', 'bing')) THEN '(organic)'
    ELSE 'referral' END AS utm_medium,
    CASE
        WHEN encoded_utm_campaign IS NOT NULL THEN REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(encoded_utm_campaign, r'\%28', '('), r'\%29', ')'), r'\%20|\+', ' ')
    ELSE '(none)' END AS utm_campaign

{%- endmacro %}