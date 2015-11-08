# determine the data directory according to the XDG Base Directory Specification
if [[ -n ${XDG_DATA_HOME} ]] && [[ ${XDG_DATA_HOME} == *${USER}* ]]; then
    export AUTOJUMP_DATA_DIR="${XDG_DATA_HOME}/autojump"
else
    export AUTOJUMP_DATA_DIR=${HOME}/.local/share/autojump
fi

if [[ ! -e ${AUTOJUMP_DATA_DIR} ]]; then
    mkdir -p "${AUTOJUMP_DATA_DIR}"
fi

# set paths if necessary for local installations
if [[ -d ${HOME}/.autojump ]]; then
    path=(${HOME}/.autojump/bin ${path})
    fpath=(${HOME}/.autojump/functions/ ${fpath})
fi

# set fpath if necessary for homebrew installation
command -v brew &>/dev/null \
    && [[ -d "`brew --prefix`/share/zsh/site-functions" ]] \
    && fpath=(`brew --prefix`/share/zsh/site-functions ${fpath})

function autojump_chpwd() {
    if [[ "${AUTOJUMP_KEEP_SYMLINKS}" == "1" ]]; then
        _PWD_ARGS=""
    else
        _PWD_ARGS="-P"
    fi
    { (autojump -a "$(pwd ${_PWD_ARGS})"&)>/dev/null 2>>|${AUTOJUMP_DATA_DIR}/autojump_errors ; } 2>/dev/null
}

typeset -ga chpwd_functions
chpwd_functions+=autojump_chpwd

function j {
    # Cannot use =~ due to MacPorts zsh v4.2, see issue #125.
    if [[ ${@} == -* ]]; then
        autojump ${@}
        return
    fi

    local new_path="$(autojump ${@})"
    if [ -d "${new_path}" ]; then
        echo -e "\\033[31m${new_path}\\033[0m"
        cd "${new_path}"
    else
        echo "autojump: directory '${@}' not found"
        echo "Try \`autojump --help\` for more information."
        false
    fi
}

function jc {
    if [[ ${@} == -* ]]; then
        j ${@}
    else
        j $(pwd)/ ${@}
    fi
}

function jo {
    if [ -z $(autojump $@) ]; then
        echo "autojump: directory '${@}' not found"
        echo "Try \`autojump --help\` for more information."
        false
    else
        case ${OSTYPE} in
            linux-gnu)
                xdg-open "$(autojump $@)"
                ;;
            darwin*)
                open "$(autojump $@)"
                ;;
            cygwin)
                cygstart "" $(cygpath -w -a $(pwd))
                ;;
            *)
                echo "Unknown operating system." 1>&2
                ;;
        esac
    fi
}

function jco {
    if [[ ${@} == -* ]]; then
        j ${@}
    else
        jo $(pwd) ${@}
    fi
}
