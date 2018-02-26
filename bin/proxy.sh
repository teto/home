#!/bin/sh
# TODO put it in function /other file
export http_proxy=http://proxy.iiji.jp:8080/
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
export no_proxy="localhost,127.0.0.1"
# otherwise won't work
export NIX_REMOTE=


