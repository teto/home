#!/usr/bin/env python

import xrandr as x

monitors = []
monitors = x.list_connected_monitors( )

cmd=x.build_xrandr_command(monitors)
print(cmd)
