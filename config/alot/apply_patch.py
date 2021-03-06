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

import logging
import os
import subprocess
import tempfile

from alot.settings.utils import read_config
# .completion
from alot.completion.path import PathCompleter



def _get_config():
    config_path = os.path.join(
        os.environ.get('XDG_CONFIG_HOME', os.path.join(os.environ['HOME'], '.config')),
        'alot', 'patch.config')
    return read_config(configpath=config_path)

async def save_mail(ui):
    # inspired by https://github.com/pazz/alot/issues/1310
    # get msg content 
    msg = ui.current_buffer.get_selected_message()
    # this is an alot.db.Message
    eml = msg.get_email() # this is an email.Message
    # open file and write str(eml)..
    # with tempfile.NamedTemporaryFile

    with tempfile.NamedTemporaryFile(mode='w+', prefix="alot-", delete=False) as out:
        # or use bytes() in binary mode ?
        out.write(str(eml))

        ui.notify("saved to %s" % out.name, priority='normal', timeout=15)

CONFIG = _get_config()


# todo creer un completer depuis le fichier de config

# def apply_patch(ui):
    # asyncio.run(apply_patch_async)

async def apply_patch(ui):

    ui.notify('expecting prompt launched !', priority='error')
    fromaddress = yield ui.prompt('Git repository')

    ui.notify('HOOK launched !', priority='error')
    # message = ui.current_buffer.get_selected_message()
    # filename = message.get_filename()

    # for tag in message.get_tags():
    #     if tag in CONFIG:
    #         config = CONFIG[tag]
    #         break
    # else:
    #     logging.debug('found: ' + ', '.join(message.get_tags()))
    #     ui.notify('No tags matched a config rule!', priority='error')
    #     return


    # async def greet(ui):  # ui is instance of alot.ui.UI
    #     name = await ui.prompt('pls enter your name')
    #     ui.notify('your name is: ' + name)

    # try:
    #     cmpl = PathCompleter()
    #     # TODO add/filter paths
    #     # await 
    #             # completer=cmpl, tab=1, history=ui.senderhistory
    #     # ui.prompt("")

    #     ui.notify('selected path :' + str(e), priority='error')
    #     subprocess.check_output(
    #         ['git', '-C', os.path.expanduser(config['directory']), 'am', '-3', filename],
    #         stderr=subprocess.STDOUT)
    # except Exception as e:
    #     ui.notify('Failed to apply patch. Reason:' + str(e), priority='error')
    #     logging.debug('git am output: ' + e.output)
    # else:
    #     ui.notify('Patch applied.', priority='error')
