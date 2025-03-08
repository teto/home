#!/usr/bin/env python

import subprocess
import datetime
import json
from html import escape

data = {}

today = datetime.date.today().strftime("%Y-%m-%d")

# next_week = (datetime.date.today() +
#              datetime.timedelta(days=10)).strftime("%Y-%m-%d")
until_date = "tomorrow"

output = subprocess.check_output("khal list now "+ until_date, shell=True)
output = output.decode("utf-8")

lines = output.split("\n")

# The output of `khal list` looks like:
# Today, 03/02/2025
# ↔ volley-ball with friends
new_lines = []
for line in lines:
    clean_line = escape(line).split(" ::")[0]
    if len(clean_line) and not clean_line[0] in ['0', '1', '2']:
        clean_line = "\n<b>"+clean_line+"</b>"
    new_lines.append(clean_line)
output = "\n".join(new_lines).strip()

if today in output:
    data['text'] = " " + output.split('\n')[1]
else:
    data['text'] = ""

data['tooltip'] = output

print(json.dumps(data))

