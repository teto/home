# -*- coding: utf-8 -*-

import logging
from i3pystatus.mail import notmuchmail
import keyring.backends.netrc as backend
from i3pystatus import Status
# from i3pystatus.core.netrc_backend import NetrcBackend

status = Status(standalone=True)

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
clock = status.register(
    "clock",
    format=[
        # ("%a %-d Format 1",'Europe/Dublin'),
        # "%a %-d %b %X ",
        ("%a %-d %b %X", 'Europe/Paris'),
        ("Format 0", 'Europe/London'),
    ],
    on_leftclick=["urxvtc"],
    # on_clicks={
    #     'left': ["urxvtc"],
    #     'upscroll': ["next_format", 1],
    #     'downscroll': ["next_format", -1]
    # },
    log_level=logging.DEBUG,
)

# clock.on_click(1)
# print(clock.on_clicks)
# status.register("pulseaudio")
# Shows your CPU temperature, if you have a Intel CPU
#status.register("temp",   format="{temp:.0f}°C",)

# The battery monitor has many formatting options, see README for details

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via dbus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
# status.register("battery",
#    format="{status}/{consumption:.2f}W {percentage:.2f}% [{percentage_design:.2f}%] {remaining:%E%hh:%Mm}",
#   alert=True,
#  alert_percentage=5,
# status={
#    "DIS": "↓",
#   "CHR": "↑",
#  "FULL": "=",
# },)

# This would look like this:
# Discharging 6h:51m
status.register("battery",
                format="{status}{remaining}",
                alert=True,
                alert_percentage=5,
                status={
                    "DIS": "Discharging",
                    "CHR": "Charging",
                    "FULL": "Bat full",
                },)
# status.register("shell",
#                 command="zisizimpossible"
#                 ,
#                 log_level=logging.DEBUG)

# Displays whether a DHCP client is running
# status.register("runwatch",
# name="DHCP",
# path="/var/run/dhclient*.pid",)

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces-py3
status.register("network",
                format_up="{v4cidr}",
                )

# Has all the options of the normal network and adds some wireless specific things
# like quality and network names.
#
# Note: requires both netifaces-py3 and basiciw
# status.register("wireless",
#   interface="wlan0",
#  format_up="{essid} {quality:03.0f}%",)


# Shows pulseaudio default sink volume
# Note: requires libpulseaudio from PyPI
#status.register("pulseaudio",   format="♪{volume}",)

status.register("pomodoro")
# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain

status.register(
    "mpd",
    format="{status}{title}",
    status={
        "pause": "▷",
        "play": "▶",
        "stop": "◾",
    },
    on_leftclick="hello world"
)

#print("mdp on_lclick", mpd);

alsa = status.register("alsa",)

# print("alsa")
res = status.register(
    "mail",
    backends=[
        notmuchmail.Notmuch(account="lip6", query="tag:inbox and tag:unread"),
        notmuchmail.Notmuch(account="gmail", query="tag:inbox and tag:unread"),
    ],
    hide_if_null=False,
    interval=1,
    # on_clicks={'left', "urxvtc -e mutt"},
    log_level=logging.DEBUG
)


#res = status.register("github",
        #username="teto",
        #interval=5,
        ##password="placeholder",
        #format="hello world: {unread} {unread_count}",
        ## keyring_backend="netrc",
        ## keyring_backend=keyring.backend.netrc,
        #keyring_backend=backend.NetrcBackend,
        #log_level=logging.DEBUG,
        #)
#print("Result:", res)
# res.on_leftclick()
status.run()
