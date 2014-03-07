{% include "colors/"+theme+"/common.tpl" %}

{%macro add_bar(position="top",command="i3bar",theme="default") %}

bar {
    position {{ position }}
    status_command {{ command }}

    {% include "colors/"+theme+"/bar.tpl" %}

{% endmacro %}

{# }
{% for output in outputs %}
    {% set outer_loop = loop %}
    {% for binding,workspaceName in output.ws %}
        set $workspace{{ outer_loop.index}} {{workspaceName}}
    {%- endfor -%}
{%- endfor -%}
{#}

{%- for workspace in range( 1 + workspaceNames | length, 10) %}
set $workspace{{workspace}} {{ workspace }}
{%- endfor %}

set $mod {{ modifier }}

set $terminal {{terminal}}

## group by


# The IPC interface allows programs like an external workspace bar
# (i3-wsbar) or i3-msg (can be used to "remote-control" i3) to work.
ipc-socket {{ipc_socket}}

{% for bar in outputs|map(attribute="bar") %}
#set $output{{loop.index}} {{ output }}
# TODO bind a bar to an output
    {{ add_bar() }}
    
{% endfor %}


# without context

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod             


{% for tpl,config in mods %}
    # Module {{tpl}}
    {{ config }}
    {% include tpl %}
{% endfor %}

# Ca doit aller dans les themes

{#
{% for wsName in wsList  %}
#}
{% for wsList in outputs|map(attribute="ws") %}
    {% for wsName,bind in wsList  %}
    bindsym $mod+{{bind}} workspace "{{wsName}}"
    bindsym $mod+Shift+{{bind}} move container to workspace "{{wsName}}"
    {% endfor %}

{% endfor %}


{{ self|pprint }}