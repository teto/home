#!/usr/bin/python2

# READ http://alot.readthedocs.org/en/docs/configuration/index.html#hooks
import logging
import subprocess

from alot.settings import settings

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

def pre_global_refresh(**kwargs):
    logging.info('Syncing mail with offlineimap')
    
    # TODO run into another thread
    subprocess.call(["offlineimap"])
