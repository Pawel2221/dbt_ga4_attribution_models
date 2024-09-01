{%- macro ga4_unnest_key(column_to_unnest, key_to_extract, value_type) -%}
    (
        SELECT
            value.{{ value_type }}
        FROM UNNEST({{ column_to_unnest }}) 
        WHERE key = '{{ key_to_extract }}'
    )
{%- endmacro %}


