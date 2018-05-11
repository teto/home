# -*- encoding: utf-8 -*-
# READ http://alot.readthedocs.org/en/docs/configuration/index.html#hooks
import logging
import subprocess

# from alot.settings import settings

#run offlineimaponexit
# def pre_global_exit(**kwargs):
    # accounts = settings.get_accounts()
    # logging.info('Syncing mail with offlineimap')

    # subprocess.call(["offlineimap"])

    # if accounts:
        # logging.info('goodbye, %s!' % accounts[0].realname)
    # else:
        # logging.info('goodbye!')

def myhook(**kwargs):
    logging.info('hook called')
def pre_global_exit(ui, dbm, cmd):
    logging.info('Exiting .. MAt')

# pre/post_MODE_COMMAND(ui, dbm, **)
def pre_search_refineprompt(ui, dbm, cmd, **kwargs):
    # of type refinepromptcommand
    logging.info('hook called with cmd %s' % cmd)
    sbuffer = ui.current_buffer
    oldquery = sbuffer.querystring
    match = False
    logging.debug("query before=%s" % oldquery)

    logging.debug("query type = %r" % oldquery)
    for pattern in ["AND tag:unread", "tag:unread"]:
        if pattern in oldquery:
            match = True
            oldquery = oldquery.replace("tag:unread", '')
    if not match:
        oldquery = "tag:unread AND " + oldquery

    logging.debug("query after=%s" % oldquery)
    # cmd.querystring += " tag:toto"
    sbuffer.querystring = oldquery
    return ui.apply_command


# could be added to HM hooks
def pre_global_refresh(**kwargs):
    logging.info('Syncing mail with offlineimap')
    
    # TODO run into another thread
    subprocess.call(["offlineimap"])


# Copyright © 2017 Dylan Baker
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os
import subprocess

from alot.settings.utils import read_config



def _get_config():
    config_path = os.path.join(
        os.environ.get('XDG_CONFIG_HOME', os.path.join(os.environ['HOME'], '.config')),
        'alot', 'patch.config')
    return read_config(configpath=config_path)



def apply_patch(ui):
    CONFIG = _get_config()
    message = ui.current_buffer.get_selected_message()
    filename = message.get_filename()

    for tag in message.get_tags():
        ui.notify("looking for tag %s!" % tag)
        #, priority='error')
        if tag in CONFIG:
            config = CONFIG[tag]
            break
    else:
        logging.debug('found: ' + ', '.join(message.get_tags()))
        ui.notify('No tags matched a config rule!', priority='error')
        return

    try:

        thread_id = message.get_thread_id()
        logging.debug("Extracting patches ! %r" % thread_id)
        ui.notify("Extracting patches ! %r" % thread_id, priority='normal')
        # > feature.patchset
        subprocess.check_output(
            ["notmuch-extract-patch", "thread:%s" % thread_id ],
            # ['git', '-C', os.path.expanduser(config['directory']), 'am', '-3', filename],
            stderr=subprocess.STDOUT)
    except Exception as e:
        ui.notify('Failed to apply patch. Reason:' + str(e), timeout=-1, priority='error')
        logging.debug('git am output: ' + str(e))
    else:
        ui.notify('Patch applied.')


#def apply_patch2(ui):
#    CONFIG = _get_config()
#    message = ui.current_buffer.get_selected_message()
#    filename = message.get_filename()

#    for tag in message.get_tags():
#        ui.notify("looking for tag %s!" % tag)
#        #, priority='error')
#        if tag in CONFIG:
#            config = CONFIG[tag]
#            break
#    else:
#        logging.debug('found: ' + ', '.join(message.get_tags()))
#        ui.notify('No tags matched a config rule!', priority='error')
#        return

#    try:
#        subprocess.check_output(
#            ['git', '-C', os.path.expanduser(config['directory']), 'am', '-3', filename],
#            stderr=subprocess.STDOUT)
#    except Exception as e:
#        ui.notify('Failed to apply patch. Reason:' + str(e), priority='error')
#        logging.debug('git am output: ' + str(e))
#    else:
#        ui.notify('Patch applied.')
