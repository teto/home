# doc at https://sw.kovidgoyal.net/kitty/kittens/custom/
from kitty.boss import Boss
from kittens.tui.handler import result_handler
import sys
import os
from kittens.tui.loop import debug
from kitty.constants import kitten_exe

# os.execlp(kitten_exe(), 'kitten', *sys.argv)


# examples of kittens
# - https://github.com/dnanhkhoa/kitty-password-manager/blob/main/password_manager.py  has good example on how to launch stuff
# - https://github.com/knubie/vim-kitty-navigator/blob/master/pass_keys.py
# - builtins remote_file and resize-window are python-based

# @result_handler(no_ui=True)
# window.write_to_child(encoded)

OPTIONS = r'''
toto
'''

usage = 'TITLE [BODY ...]'
if __name__ == '__main__':
    raise SystemExit('This should be run as `kitten rikai ...`')
# elif __name__ == '__doc__':
#     cd = sys.cli_docs  # type: ignore
#     cd['usage'] = usage
#     cd['options'] = OPTIONS
#     cd['help_text'] = help_text
#     cd['short_desc'] = 'Send notifications to the user'

def print_intro() -> None:
    print("kitten main called")

# in main, STDIN is for the kitten process and will contain
# the contents of the screen
def main(args: list[str]) -> str:
    # this is the main entry point of the kitten, it will be executed in
    # the overlay window when the kitten is launched
    # answer = input('Enter some text: ')
    # whatever this function returns will be available in the
    # handle_result() function
    # print_intro()
    content = sys.stdin.read()
    # return sys.stdin.read()
    # 'kitten',
    # debug(*sys.argv)
    # os.execlp("nvim",  *sys.argv)

    pass
    # return answer

# in handle_result, STDIN is for the kitty process itself, rather
# than the kitten process and should not be read from.
# type of input is seen here 
@result_handler(type_of_input='selection')
def handle_result(args: list[str], stdin_data: str, target_window_id: int, boss: Boss) -> None:
    # get the kitty window into which to paste answer
    debug('whatever')
    w = boss.window_id_map.get(target_window_id)
    # print("TOTO")
    if w is not None:
        w.paste_text("toto")
        # import time
        # time.sleep(3)
    pass
