# common to sh/zsh
function rfw(){
    readlink -f $(which "$1")
}

