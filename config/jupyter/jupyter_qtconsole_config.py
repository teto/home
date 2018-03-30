# Configuration file for ipython-qtconsole.

c = get_config()
# https://bitbucket.org/joon/color-schemes-for-ipython-qt-console
# color_theme = 'solarizedlight'  # specify color theme
# monokai/ solarizeddark / zenburn
# import pkg_resources
# c.JupyterQtConsoleApp.stylesheet = pkg_resources.resource_filename(
#      "jupyter_qtconsole_colorschemes", "{}.css".format(color_theme))


#------------------------------------------------------------------------------
# JupyterQtConsoleApp configuration
#------------------------------------------------------------------------------

# JupyterQtConsoleApp will inherit config from: BaseIPythonApplication,
# Application, IPythonConsoleApp, ConnectionFileMixin

# Whether to overwrite existing config files when copying
# c.JupyterQtConsoleApp.overwrite = False

# set the iopub (PUB) port [default: random]
# c.JupyterQtConsoleApp.iopub_port = 0

# The IPython profile to use.
# c.JupyterQtConsoleApp.profile = 'default'

# Path to the ssh key to use for logging in to the ssh server.
# c.JupyterQtConsoleApp.sshkey = ''

# Connect to an already running kernel
# c.JupyterQtConsoleApp.existing = ''

# The date format used by logging formatters for %(asctime)s
# c.JupyterQtConsoleApp.log_datefmt = '%Y-%m-%d %H:%M:%S'

# Path to an extra config file to load.
# 
# If specified, load this config file in addition to any other IPython config.
# c.JupyterQtConsoleApp.extra_config_file = ''

# Use a plaintext widget instead of rich text (plain can't print/save).
# c.JupyterQtConsoleApp.plain = False

# Set the log level by value or name.
# c.JupyterQtConsoleApp.log_level = 30

# path to a custom CSS stylesheet
# c.JupyterQtConsoleApp.stylesheet = ''

# Whether to create profile dir if it doesn't exist
# c.JupyterQtConsoleApp.auto_create = False

# Set to display confirmation dialog on exit. You can always use 'exit' or
# 'quit', to force a direct exit without any confirmation.
# c.JupyterQtConsoleApp.confirm_exit = True

# The SSH server to use to connect to the kernel.
# c.JupyterQtConsoleApp.sshserver = ''

# The name of the IPython directory. This directory is used for logging
# configuration (through profiles), history storage, etc. The default is usually
# $HOME/.ipython. This options can also be specified through the environment
# variable IPYTHONDIR.
# c.JupyterQtConsoleApp.ipython_dir = ''

# Start the console window maximized.
# c.JupyterQtConsoleApp.maximize = False

# Start the console window with the menu bar hidden.
# c.JupyterQtConsoleApp.hide_menubar = False

# Whether to install the default config files into the profile dir. If a new
# profile is being created, and IPython contains config files for that profile,
# then they will be staged into the new directory.  Otherwise, default config
# files will be automatically generated.
# c.JupyterQtConsoleApp.copy_config_files = False

# 
# c.JupyterQtConsoleApp.transport = 'tcp'

# set the stdin (DEALER) port [default: random]
# c.JupyterQtConsoleApp.stdin_port = 0

# The Logging format template
# c.JupyterQtConsoleApp.log_format = '[%(name)s]%(highlevel)s %(message)s'

# set the shell (ROUTER) port [default: random]
# c.JupyterQtConsoleApp.shell_port = 0

# JSON file in which to store connection info [default: kernel-<pid>.json]
# 
# This file will contain the IP, ports, and authentication key needed to connect
# clients to this kernel. By default, this file will be created in the security-
# dir of the current profile, but can be specified by absolute path.
# c.JupyterQtConsoleApp.connection_file = ''

# Set the kernel's IP address [default localhost]. If the IP address is
# something other than localhost, then Consoles on other machines will be able
# to connect to the Kernel, so be careful!
# c.JupyterQtConsoleApp.ip = ''

# set the heartbeat port [default: random]
# c.JupyterQtConsoleApp.hb_port = 0

# Create a massive crash report when IPython encounters what may be an internal
# error.  The default is to append a short message to the usual traceback
# c.JupyterQtConsoleApp.verbose_crash = False

#------------------------------------------------------------------------------
# JupyterWidget configuration
#------------------------------------------------------------------------------

# A FrontendWidget for an IPython kernel.

# JupyterWidget will inherit config from: FrontendWidget, HistoryConsoleWidget,
# ConsoleWidget

# The type of completer to use. Valid values are:
# 
# 'plain'   : Show the available completion as a text list
#             Below the editing area.
# 'droplist': Show the completion in a drop down list navigable
#             by the arrow keys, and from which you can select
#             completion by pressing Return.
# 'ncurses' : Show the completion as a text list which is navigable by
#             `tab` and arrow keys.
# c.JupyterWidget.gui_completion = 'ncurses'

# Whether to ask for user confirmation when restarting kernel
# c.JupyterWidget.confirm_restart = True

# The height of the console at start time in number of characters (will double
# with `vsplit` paging)
# c.JupyterWidget.height = 25

# Whether to clear the console when the kernel is restarted
# c.JupyterWidget.clear_on_kernel_restart = True

# A command for invoking a system text editor. If the string contains a
# {filename} format specifier, it will be used. Otherwise, the filename will be
# appended to the end the command.
# c.JupyterWidget.editor = ''

# The pygments lexer class to use.
# c.JupyterWidget.lexer_class = <IPython.utils.traitlets.Undefined object at 0x7f7a5d221080>

# Whether to process ANSI escape codes.
# c.JupyterWidget.ansi_codes = True

# The type of paging to use. Valid values are:
# 
# 'inside'
#    The widget pages like a traditional terminal.
# 'hsplit'
#    When paging is requested, the widget is split horizontally. The top
#    pane contains the console, and the bottom pane contains the paged text.
# 'vsplit'
#    Similar to 'hsplit', except that a vertical splitter is used.
# 'custom'
#    No action is taken by the widget beyond emitting a
#    'custom_page_requested(str)' signal.
# 'none'
#    The text is written directly to the console.
# c.JupyterWidget.paging = 'inside'

# The maximum number of lines of text before truncation. Specifying a non-
# positive number disables text truncation (not recommended).
# c.JupyterWidget.buffer_size = 500

# Whether to draw information calltips on open-parentheses.
# c.JupyterWidget.enable_calltips = True

# If not empty, use this Pygments style for syntax highlighting. Otherwise, the
# style sheet is queried for Pygments style information.
# c.JupyterWidget.syntax_style = ''

# The font size. If unconfigured, Qt will be entrusted with the size of the
# font.
# c.JupyterWidget.font_size = 0

# 
# c.JupyterWidget.input_sep = '\n'

# The font family to use for the console. On OSX this defaults to Monaco, on
# Windows the default is Consolas with fallback of Courier, and on other
# platforms the default is Monospace.
# c.JupyterWidget.font_family = ''

# The editor command to use when a specific line number is requested. The string
# should contain two format specifiers: {line} and {filename}. If this parameter
# is not specified, the line number option to the %edit magic will be ignored.
# c.JupyterWidget.editor_line = ''

# Whether to automatically execute on syntactically complete input.
# 
# If False, Shift-Enter is required to submit each execution. Disabling this is
# mainly useful for non-Python kernels, where the completion check would be
# wrong.
# c.JupyterWidget.execute_on_complete_input = True

# 
# c.JupyterWidget.output_sep = ''

# The type of underlying text widget to use. Valid values are 'plain', which
# specifies a QPlainTextEdit, and 'rich', which specifies a QTextEdit.
# c.JupyterWidget.kind = 'plain'

# 
# c.JupyterWidget.in_prompt = 'In [<span class="in-prompt-number">%i</span>]: '

# 
# c.JupyterWidget.output_sep2 = ''

# The width of the console at start time in number of characters (will double
# with `hsplit` paging)
# c.JupyterWidget.width = 81

# 
# c.JupyterWidget.out_prompt = 'Out[<span class="out-prompt-number">%i</span>]: '

# 
# c.JupyterWidget.banner = ''

# 
# c.JupyterWidget.history_lock = False

# A CSS stylesheet. The stylesheet can contain classes for:
#     1. Qt: QPlainTextEdit, QFrame, QWidget, etc
#     2. Pygments: .c, .k, .o, etc. (see PygmentsHighlighter)
#     3. IPython: .error, .in-prompt, .out-prompt, etc
# c.JupyterWidget.style_sheet = ''

#------------------------------------------------------------------------------
# IPKernelApp configuration
#------------------------------------------------------------------------------

# IPython: an enhanced interactive Python shell.

# IPKernelApp will inherit config from: BaseIPythonApplication, Application,
# InteractiveShellApp

# If true, IPython will populate the user namespace with numpy, pylab, etc. and
# an ``import *`` is done from numpy and pylab, when using pylab mode.
# 
# When False, pylab mode should not import any names into the user namespace.
# c.IPKernelApp.pylab_import_all = True

# set the iopub (PUB) port [default: random]
# c.IPKernelApp.iopub_port = 0

# dotted module name of an IPython extension to load.
# c.IPKernelApp.extra_extension = ''

# Should variables loaded at startup (by startup files, exec_lines, etc.) be
# hidden from tools like %who?
# c.IPKernelApp.hide_initial_ns = True

# set the stdin (ROUTER) port [default: random]
# c.IPKernelApp.stdin_port = 0

# The IPython profile to use.
# c.IPKernelApp.profile = 'default'

# Whether to overwrite existing config files when copying
# c.IPKernelApp.overwrite = False

# kill this process if its parent dies.  On Windows, the argument specifies the
# HANDLE of the parent process, otherwise it is simply boolean.
# c.IPKernelApp.parent_handle = 0

# Run the file referenced by the PYTHONSTARTUP environment variable at IPython
# startup.
# c.IPKernelApp.exec_PYTHONSTARTUP = True

# Configure matplotlib for interactive use with the default matplotlib backend.
# to check if value is correctly loaded, you can run %config IPKernelApp.matplotlib from ipython
c.IPKernelApp.matplotlib = "inline"

# Path to an extra config file to load.
# 
# If specified, load this config file in addition to any other IPython config.
# c.IPKernelApp.extra_config_file = ''

# List of files to run at IPython startup.
# c.IPKernelApp.exec_files = []

# The Kernel subclass to be used.
# 
# This should allow easy re-use of the IPKernelApp entry point to configure and
# launch kernels other than IPython's own.
# c.IPKernelApp.kernel_class = 'IPython.kernel.zmq.ipkernel.Kernel'

# Set the log level by value or name.
# c.IPKernelApp.log_level = 30

# A list of dotted module names of IPython extensions to load.
# c.IPKernelApp.extensions = []

# Whether to create profile dir if it doesn't exist
# c.IPKernelApp.auto_create = False

# lines of code to run at IPython startup.
# c.IPKernelApp.exec_lines = []

# The name of the IPython directory. This directory is used for logging
# configuration (through profiles), history storage, etc. The default is usually
# $HOME/.ipython. This options can also be specified through the environment
# variable IPYTHONDIR.
# c.IPKernelApp.ipython_dir = ''

# The date format used by logging formatters for %(asctime)s
# c.IPKernelApp.log_datefmt = '%Y-%m-%d %H:%M:%S'

# The importstring for the OutStream factory
# c.IPKernelApp.outstream_class = 'IPython.kernel.zmq.iostream.OutStream'

# Execute the given command string.
# c.IPKernelApp.code_to_run = ''

# Whether to install the default config files into the profile dir. If a new
# profile is being created, and IPython contains config files for that profile,
# then they will be staged into the new directory.  Otherwise, default config
# files will be automatically generated.
# c.IPKernelApp.copy_config_files = False

# 
# c.IPKernelApp.transport = 'tcp'

# 
# c.IPKernelApp.parent_appname = ''

# ONLY USED ON WINDOWS Interrupt this process when the parent is signaled.
# c.IPKernelApp.interrupt = 0

# Enable GUI event loop integration with any of ('glut', 'gtk', 'gtk3', 'none',
# 'osx', 'pyglet', 'qt', 'qt4', 'tk', 'wx').
# c.IPKernelApp.gui = None

# The Logging format template
# c.IPKernelApp.log_format = '[%(name)s]%(highlevel)s %(message)s'

# set the shell (ROUTER) port [default: random]
# c.IPKernelApp.shell_port = 0

# redirect stderr to the null device
# c.IPKernelApp.no_stderr = False

# Run the module as a script.
# c.IPKernelApp.module_to_run = ''

# JSON file in which to store connection info [default: kernel-<pid>.json]
# 
# This file will contain the IP, ports, and authentication key needed to connect
# clients to this kernel. By default, this file will be created in the security
# dir of the current profile, but can be specified by absolute path.
# c.IPKernelApp.connection_file = ''

# The importstring for the DisplayHook factory
# c.IPKernelApp.displayhook_class = 'IPython.kernel.zmq.displayhook.ZMQDisplayHook'

# redirect stdout to the null device
# c.IPKernelApp.no_stdout = False

# set the heartbeat port [default: random]
# c.IPKernelApp.hb_port = 0

# Pre-load matplotlib and numpy for interactive use, selecting a particular
# matplotlib backend and loop integration.
# c.IPKernelApp.pylab = None

# set the control (ROUTER) port [default: random]
# c.IPKernelApp.control_port = 0

# Create a massive crash report when IPython encounters what may be an internal
# error.  The default is to append a short message to the usual traceback
# c.IPKernelApp.verbose_crash = False

# A file to be run
# c.IPKernelApp.file_to_run = ''

# Set the IP or interface on which the kernel will listen.
# c.IPKernelApp.ip = ''

#------------------------------------------------------------------------------
# ZMQInteractiveShell configuration
#------------------------------------------------------------------------------

# A subclass of InteractiveShell for ZMQ.

# ZMQInteractiveShell will inherit config from: InteractiveShell

# 
# c.ZMQInteractiveShell.debug = False

# Set the color scheme (NoColor, Linux, or LightBG).
# c.ZMQInteractiveShell.colors = 'LightBG'

# Don't call post-execute functions that have failed in the past.
# c.ZMQInteractiveShell.disable_failing_post_execute = False

# 
# c.ZMQInteractiveShell.separate_out2 = ''

# 
# c.ZMQInteractiveShell.readline_remove_delims = '-/~'

# Use colors for displaying information about objects. Because this information
# is passed through a pager (like 'less'), and some pagers get confused with
# color codes, this capability can be turned off.
# c.ZMQInteractiveShell.color_info = True

# 
# c.ZMQInteractiveShell.separate_out = ''

# 
# c.ZMQInteractiveShell.separate_in = '\n'

# Start logging to the default log file.
# c.ZMQInteractiveShell.logstart = False

# Deprecated, use PromptManager.in2_template
# c.ZMQInteractiveShell.prompt_in2 = '   .\\D.: '

# Automatically call the pdb debugger after every exception.
# c.ZMQInteractiveShell.pdb = False

# Deprecated, use PromptManager.out_template
# c.ZMQInteractiveShell.prompt_out = 'Out[\\#]: '

# Enable magic commands to be called without the leading %.
# c.ZMQInteractiveShell.automagic = True

# The name of the logfile to use.
# c.ZMQInteractiveShell.logfile = ''

# 
# c.ZMQInteractiveShell.ipython_dir = ''

# 
# c.ZMQInteractiveShell.readline_parse_and_bind = ['tab: complete', '"\\C-l": clear-screen', 'set show-all-if-ambiguous on', '"\\C-o": tab-insert', '"\\C-r": reverse-search-history', '"\\C-s": forward-search-history', '"\\C-p": history-search-backward', '"\\C-n": history-search-forward', '"\\e[A": history-search-backward', '"\\e[B": history-search-forward', '"\\C-k": kill-line', '"\\C-u": unix-line-discard']

# Make IPython automatically call any callable object even if you didn't type
# explicit parentheses. For example, 'str 43' becomes 'str(43)' automatically.
# The value can be '0' to disable the feature, '1' for 'smart' autocall, where
# it is not applied if there are no more arguments on the line, and '2' for
# 'full' autocall, where all callable objects are automatically called (even if
# no arguments are present).
# c.ZMQInteractiveShell.autocall = 0

# 
# c.ZMQInteractiveShell.wildcards_case_sensitive = True

# Show rewritten input, e.g. for autocall.
# c.ZMQInteractiveShell.show_rewritten_input = True

# 
# c.ZMQInteractiveShell.xmode = 'Context'

# Enable deep (recursive) reloading by default. IPython can use the deep_reload
# module which reloads changes in modules recursively (it replaces the reload()
# function, so you don't need to change anything to use it). deep_reload()
# forces a full reload of modules whose code may have changed, which the default
# reload() function does not.  When deep_reload is off, IPython will use the
# normal reload(), but deep_reload will still be available as dreload().
# c.ZMQInteractiveShell.deep_reload = False

# Set the size of the output cache.  The default is 1000, you can change it
# permanently in your config file.  Setting it to 0 completely disables the
# caching system, and the minimum value accepted is 20 (if you provide a value
# less than 20, it is reset to 0 and a warning is issued).  This limit is
# defined because otherwise you'll spend more time re-flushing a too small cache
# than working
# c.ZMQInteractiveShell.cache_size = 1000

# Save multi-line entries as one entry in readline history
# c.ZMQInteractiveShell.multiline_history = True

# 
# c.ZMQInteractiveShell.quiet = False

# 
# c.ZMQInteractiveShell.history_length = 10000

# Deprecated, use PromptManager.justify
# c.ZMQInteractiveShell.prompts_pad_left = True

# Start logging to the given file in append mode.
# c.ZMQInteractiveShell.logappend = ''

# 'all', 'last', 'last_expr' or 'none', specifying which nodes should be run
# interactively (displaying output from expressions).
# c.ZMQInteractiveShell.ast_node_interactivity = 'last_expr'

# 
# c.ZMQInteractiveShell.object_info_string_level = 0

# A list of ast.NodeTransformer subclass instances, which will be applied to
# user input before code is run.
# c.ZMQInteractiveShell.ast_transformers = []

# Deprecated, use PromptManager.in_template
# c.ZMQInteractiveShell.prompt_in1 = 'In [\\#]: '

#------------------------------------------------------------------------------
# KernelManager configuration
#------------------------------------------------------------------------------

# Manages a single kernel in a subprocess on this host.
# 
# This version starts kernels with Popen.

# KernelManager will inherit config from: ConnectionFileMixin

# The Popen Command to launch the kernel. Override this if you have a custom
# kernel. If kernel_cmd is specified in a configuration file, IPython does not
# pass any arguments to the kernel, because it cannot make any assumptions about
# the  arguments that the kernel understands. In particular, this means that the
# kernel does not receive the option --debug if it given on the IPython command
# line.
# c.KernelManager.kernel_cmd = []

# Should we autorestart the kernel if it dies.
# c.KernelManager.autorestart = False

# 
# c.KernelManager.transport = 'tcp'

# Set the kernel's IP address [default localhost]. If the IP address is
# something other than localhost, then Consoles on other machines will be able
# to connect to the Kernel, so be careful!
# c.KernelManager.ip = ''

#------------------------------------------------------------------------------
# ProfileDir configuration
#------------------------------------------------------------------------------

# An object to manage the profile directory and its resources.
# 
# The profile directory is used by all IPython applications, to manage
# configuration, logging and security.
# 
# This object knows how to find, create and manage these directories. This
# should be used by any code that wants to handle profiles.

# Set the profile location directly. This overrides the logic used by the
# `profile` option.
# c.ProfileDir.location = ''

#------------------------------------------------------------------------------
# Session configuration
#------------------------------------------------------------------------------

# Object for handling serialization and sending of messages.
# 
# The Session object handles building messages and sending them with ZMQ sockets
# or ZMQStream objects.  Objects can communicate with each other over the
# network via Session objects, and only need to work with the dict-based IPython
# message spec. The Session will handle serialization/deserialization, security,
# and metadata.
# 
# Sessions support configurable serialization via packer/unpacker traits, and
# signing with HMAC digests via the key/keyfile traits.
# 
# Parameters ----------
# 
# debug : bool
#     whether to trigger extra debugging statements
# packer/unpacker : str : 'json', 'pickle' or import_string
#     importstrings for methods to serialize message parts.  If just
#     'json' or 'pickle', predefined JSON and pickle packers will be used.
#     Otherwise, the entire importstring must be used.
# 
#     The functions must accept at least valid JSON input, and output *bytes*.
# 
#     For example, to use msgpack:
#     packer = 'msgpack.packb', unpacker='msgpack.unpackb'
# pack/unpack : callables
#     You can also set the pack/unpack callables for serialization directly.
# session : bytes
#     the ID of this Session object.  The default is to generate a new UUID.
# username : unicode
#     username added to message headers.  The default is to ask the OS.
# key : bytes
#     The key used to initialize an HMAC signature.  If unset, messages
#     will not be signed or checked.
# keyfile : filepath
#     The file containing a key.  If this is set, `key` will be initialized
#     to the contents of the file.

# Threshold (in bytes) beyond which a buffer should be sent without copying.
# c.Session.copy_threshold = 65536

# The UUID identifying this session.
# c.Session.session = ''

# Debug output in the Session
# c.Session.debug = False

# Metadata dictionary, which serves as the default top-level metadata dict for
# each message.
# c.Session.metadata = {}

# Username for the Session. Default is your system username.
# c.Session.username = 'teto'

# The name of the unpacker for unserializing messages. Only used with custom
# functions for `packer`.
# c.Session.unpacker = 'json'

# Threshold (in bytes) beyond which an object's buffer should be extracted to
# avoid pickling.
# c.Session.buffer_threshold = 1024

# The maximum number of digests to remember.
# 
# The digest history will be culled when it exceeds this value.
# c.Session.digest_history_size = 65536

# The digest scheme used to construct the message signatures. Must have the form
# 'hmac-HASH'.
# c.Session.signature_scheme = 'hmac-sha256'

# execution key, for extra authentication.
# c.Session.key = b''

# The maximum number of items for a container to be introspected for custom
# serialization. Containers larger than this are pickled outright.
# c.Session.item_threshold = 64

# path to file containing execution key.
# c.Session.keyfile = ''

# The name of the packer for serializing messages. Should be one of 'json',
# 'pickle', or an import name for a custom callable serializer.
# c.Session.packer = 'json'

#------------------------------------------------------------------------------
# InlineBackend configuration
#------------------------------------------------------------------------------

# An object to store configuration of the inline backend.

# The figure format to enable (deprecated use `figure_formats` instead)
# c.InlineBackend.figure_format = ''

# Subset of matplotlib rcParams that should be different for the inline backend.
# c.InlineBackend.rc = {'figure.figsize': (6.0, 4.0), 'figure.subplot.bottom': 0.125, 'figure.facecolor': (1, 1, 1, 0), 'savefig.dpi': 72, 'figure.edgecolor': (1, 1, 1, 0), 'font.size': 10}

# Close all figures at the end of each cell.
# 
# When True, ensures that each cell starts with no active figures, but it also
# means that one must keep track of references in order to edit or redraw
# figures in subsequent cells. This mode is ideal for the notebook, where
# residual plots from other cells might be surprising.
# 
# When False, one must call figure() to create new figures. This means that
# gcf() and getfigs() can reference figures created in other cells, and the
# active figure can continue to be edited with pylab/pyplot methods that
# reference the current active figure. This mode facilitates iterative editing
# of figures, and behaves most consistently with other matplotlib backends, but
# figure barriers between cells must be explicit.
# c.InlineBackend.close_figures = True

# Extra kwargs to be passed to fig.canvas.print_figure.
# 
# Logical examples include: bbox_inches, quality (for jpeg figures), etc.
# c.InlineBackend.print_figure_kwargs = {'bbox_inches': 'tight'}

# A set of figure formats to enable: 'png',  'retina', 'jpeg', 'svg', 'pdf'.
# c.InlineBackend.figure_formats = {'png'}
