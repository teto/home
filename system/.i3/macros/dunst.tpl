{% macro notify(msg) -%}
    notify-send {{msg}}
{% endmacro %}