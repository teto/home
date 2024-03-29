#  vim: set et fdm=manual fenc=utf-8 ff=unix sts=2 sw=2 ts=4 : 
# to refresh the bar https://i3pystatus.readthedocs.io/en/latest/configuration.html#refreshing-the-bar
# 
# pkill -SIGUSR1 -f "python /home/user/.config/i3/pystatus.py"

import logging
from i3pystatus.mail import notmuchmail
# from i3pystatus.mail import maildir
#import keyring.backends.netrc as backend
from i3pystatus import Status, get_module
from copy import copy
import os
import subprocess
# from i3pystatus.updates import aptget

# TODO conditionnal import
# from i3pystatus.calendar.khal_calendar import Khal
# from i3pystatus.updates import aptget

# from i3pystatus.core.netrc_backend import NetrcBackend

cacheFolder = os.getenv("XDG_CACHE_HOME", "$HOME/.cache")

status = Status(
    standalone=True,
    logfile=cacheFolder + "/i3pystatus.log",
    click_events=True,
    # internet_check=("github.com", 22)
)

my_term = "kitty"


def change_theme(light=False):
  # echo 
  print("Changing theme to ", light)

# TODO retreive theme from pywal
status.register("text",
	text="theme",
	on_upscroll=change_theme,
	on_downscroll=change_theme,
	)

status.register("nix-channels",
    channel="nixos-unstable"
)

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
    on_leftclick="kitty ikhal",
    # on_leftclick="xmessage toto",
    # on_rightclick=["/usr/bin/urxvtc",'-e', 'cal'],
    on_rightclick="kitty sh",
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
# generate errors because of missing pacmd ?
# status.register("pulseaudio")

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

# alsa = status.register("alsa", mixer="Headphone", format="")
dpms = status.register("dpms", format="")

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

@get_module
def launch_alot(_mod):
    cmd = [
        # run sh first so that terminal survives kitty error
        "kitty", "sh", "-c", 'alot -l/tmp/alot.log -ddebug',
        # "--config",  "/home/teto/home/alot-config"
        ]
    custom_env= copy(os.environ)
    custom_env["NOTMUCH_CONFIG"] = "/home/teto/.config/notmuch/default/config"
    res = subprocess.Popen(cmd, env=custom_env)
    print(res)


res = status.register(
    "mail",
    backends=[
        # my notmuch config is in a non standard place => I have to setup db_path
        notmuchmail.Notmuch(
		  account="gmail",
		  # and in inbox/not spam
		  query="tag:unread",
		  # TODO this should be read from mail.nix
		  db_path="/home/teto/maildir",
		),
        # # notmuchmail.Notmuch(account="gmail", query="tag:inbox and tag:unread"),
    # maildir.MaildirMail(directory="/home/teto/Maildir/gmail/INBOX"),
    ],
    hide_if_null=False,
    interval=3600,
    # on_clicks={'left', "urxvtc -e mutt"},
	# TODO run an update
    on_leftclick="kitty echo $PATH",
    # on_rightclick=f"kitty 'alot -l/tmp/alot-from-bar.log'",
    # sh -c 'alot; sleep 20'
    on_rightclick=launch_alot,
    # ; sleep 10",
    log_level=logging.DEBUG
)


res = status.register("github",
        username="teto",
        interval=300,
        # #password="placeholder",
        # format="Github {unread} {unread_count}",
         # keyring_backend="netrc",
         # keyring_backend=keyring.backend.netrc,
        # keyring_backend=backend.netrcbackend,
         log_level=logging.DEBUG,
        )

# #print("result:", res)
# # res.on_leftclick()
def popup(msg):
	DesktopNotification(
		title="toto",
		body=msg,
		# icon=self.notification_icon,
		urgency=1,
		timeout=0,
	).display()


status.run()

