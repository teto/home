# -*- coding: utf-8 -*-
# to refresh the bar
#
# pkill -SIGUSR1 -f "python /home/user/.config/i3/pystatus.py"

import logging
from i3pystatus.mail import notmuchmail
# from i3pystatus.mail import maildir
#import keyring.backends.netrc as backend
from i3pystatus import Status
# from i3pystatus.updates import aptget

# TODO conditionnal import
# from i3pystatus.calendar.khal_calendar import Khal
# from i3pystatus.updates import aptget

# from i3pystatus.core.netrc_backend import NetrcBackend

status = Status(standalone=True, logfile="$HOME/i3pystatus.log", click_events=True,)

my_term = "termite"

#status.register("text",


status.register("spotify")

status.register("nix-channels")

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
# TODO click should refresh it !
clock = status.register(
    "clock",
    # %a => day
    # %X => time without date
    format=[
        # ("%a %-d Format 1",'Europe/Dublin'),
        # "%a %-d %b %X ",
        # 
        (" %a %-d %X (Paris)", 'Europe/Paris'),
        (" %a %-d %X (Tokyo)", 'Asia/Tokyo'),
    ],
    on_leftclick="termite -e ikhal",
    # on_leftclick="xmessage toto",
    # on_rightclick=["/usr/bin/urxvtc",'-e', 'cal'],
    on_rightclick="gnome-terminal -e sh",
    # interval=10,
    # on_clicks={
    #     'left': ["urxvtc"],
    #     'upscroll': ["next_format", 1],
    #     'downscroll': ["next_format", -1]
    # },
    # log_level=logging.DEBUG,
)

# status.register("xkblayout", layouts=["fr", "us"])

# clock.on_click(1)
# print(clock.on_clicks)
status.register("pulseaudio")
# Shows your CPU temperature, if you have a Intel CPU
# status.register("temp",   format="{temp:.0f}°C",)
# might not work with modesetting, nvidia etc...
status.register("backlight", format="{percentage}%",)
# redshift = status.register("redshift", )
# redshift.toggle_inhibit()
#
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
                format=" {status}{remaining}",
                alert=True,
                alert_percentage=5,
                status={
                    'DPL': 'DPL',
                    "DIS": "Discharging",
                    "CHR": "Charging",
                    "FULL": "",
                },)
# status.register("shell",
#                 command="zisizimpossible"
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
# status.register("network",
#                 format_up="{v4cidr}",
#                 hints= {"markup": "pango"},
#                 on_leftclick="ip addr show dev {interface} | xmessage -file -",
#                 )

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

# status.register(
#     "mpd",
#     format="{status}{title}",
#     status={
#         "pause": "▷",
#         "play": "▶",
#         "stop": "◾",
#     },
# on_rightclick=['termite', '-e', 'ncmpcpp']
# )

#print("mdp on_lclick", mpd);

# alsa = status.register("alsa", mixer="Headphone", format="")
dpms = status.register("dpms", format="")

# alsa = status.register("alsa",
#         on_leftclick=[my_term, '-e', 'alsamixer']
#         )

# status.register("updates",
#                 format = "Updates: {count}",
#                 format_working = "In progress",
#                 format_no_updates = "No updates",
#                 # on_leftclick=["urxvtc", '-e', 'zsh' , '-c' , 'sudo apt upgrade; zsh'],
#                 on_rightclick="run",
#                 backends = [aptget.AptGet()],
#                 # log_level=logging.DEBUG
#                 )



# status.register("rofication", 
#          log_level=logging.DEBUG,
#         )

# '~/.config/khal/config'
# status.register("calendar",  backend=Khal(config_path=None,
#    calendars=['lip6']
#    )
# # format = '{calendar} / {nb_events}'
# # days=2,
        # calendars=[],
        # format="{title}",
         # log_level=logging.DEBUG,
        # )

# status.register("scratchpad",)

res = status.register(
    "mail",
    backends=[
        # my notmuch config is in a non standard place => I have to setup db_path
        notmuchmail.Notmuch(account="gmail",
            query="tag:inbox and tag:unread",
            db_path="/home/teto/maildir",
            ),
        # # notmuchmail.Notmuch(account="gmail", query="tag:inbox and tag:unread"),
    # maildir.MaildirMail(directory="/home/teto/Maildir/gmail/INBOX"),
    ],
    hide_if_null=False,
    interval=3600,
    # on_clicks={'left', "urxvtc -e mutt"},
    on_leftclick='urxvtc -e mutt',
    log_level=logging.DEBUG
)

# res = status.register("github",
#         username="teto",
#         interval=300,
#         # #password="placeholder",
#         # format="Github {unread} {unread_count}",
#          # keyring_backend="netrc",
#          # keyring_backend=keyring.backend.netrc,
#         # keyring_backend=backend.netrcbackend,
#          log_level=logging.DEBUG,
        # )

# #print("result:", res)
# # res.on_leftclick()


status.run()

