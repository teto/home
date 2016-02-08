#!/usr/bin/env python

import logging
import subprocess

from alot.settings import settings

# run offlineimap on exit
# def pre_global_exit(**kwargs):
    # accounts = settings.get_accounts()
    # logging.info('Syncing mail with offlineimap')

    # subprocess.call(["offlineimap"])

    # if accounts:
        # logging.info('goodbye, %s!' % accounts[0].realname)
    # else:
        # logging.info('goodbye!')

def pre_global_refresh(**kwargs):
    logging.info('Syncing mail with offlineimap')

    subprocess.call(["offlineimap"])
