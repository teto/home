
https://www.guyrutenberg.com/2018/01/20/set-default-application-using-xdg-mime/

XDG_UTILS_DEBUG_LEVEL=2 xdg-mime query filetype picture.jpg
XDG_UTILS_DEBUG_LEVEL=2 xdg-mime query default image/png

xdg-mime default vlc.desktop video/mp4
xdg-mime default eog.desktop video/mp4

# to get the filetype of a file
xdg-mime query filetype cwnd_xx.png


# Then you can do
xdg-mime default qutebrowser.desktop text/html
