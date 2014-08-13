# ===== Basics
setopt beep # (no_)beep don't beep on error
setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)

# ===== Changing Directories
setopt auto_cd # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt cdablevarS # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups # don't push multiple copies of the same directory onto the directory stack

# ===== Expansion and Globbing
#setopt noextended_glob # treat #, ~, and ^ as part of patterns for filename generation


# ===== Completion 
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word    
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word # Allow completion from within a word/phrase

unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
#setopt correct # spelling correction for commands
#setopt correctall # spelling correction for arguments

# ===== Prompt
setopt prompt_subst # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
#setopt checkwinsize # redraw window if changes size
# setopt transient_rprompt # only show the rprompt on the current prompt

# ===== Scripts and Functions
#setopt multios # perform implicit tees or cats when multiple redirections are attempted
# SMART URLS
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
