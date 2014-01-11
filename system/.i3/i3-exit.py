#!/usr/bin/env python
# vim: et ts=4 sts=4 tw=4
# based on cb-exit used in CrunchBang Linux <http://crunchbanglinux.org/>

import pygtk
pygtk.require('2.0')
import gtk
import os
import getpass
import time

prefix = '$HOME/.i3/'

class i3_exit:

    def disable_buttons(self):
        self.cancel.set_sensitive(False)
        self.logout.set_sensitive(False)
        self.lock.set_sensitive(False)
        self.suspend.set_sensitive(False)
        self.hibernate.set_sensitive(False)
        self.reboot.set_sensitive(False)
        self.shutdown.set_sensitive(False)

    def cancel_action(self,btn):
        self.disable_buttons()
        gtk.main_quit()

    def logout_action(self,btn):
        self.disable_buttons()
        os.system(prefix + "i3-pre-exit")
        os.system("i3-msg exit")

    def lock_action(self,btn):
        self.disable_buttons()
        os.system(prefix + "i3-lock")
        gtk.main_quit()

    def suspend_action(self,btn):
        self.disable_buttons()
        os.system(prefix + "i3-lock")
        os.system("dbus-send --system --print-reply \
                --dest=\"org.freedesktop.UPower\"   \
                /org/freedesktop/UPower             \
                org.freedesktop.UPower.Suspend")
        gtk.main_quit()

    def hibernate_action(self,btn):
        self.disable_buttons()
        os.system(prefix + "i3-lock")
        os.system("dbus-send --system --print-reply \
                --dest=\"org.freedesktop.UPower\"   \
                /org/freedesktop/UPower             \
                org.freedesktop.UPower.Hibernate")
        gtk.main_quit()

    def reboot_action(self,btn):
        self.disable_buttons()
        os.system(prefix + 'i3-pre-exit')
        os.system("dbus-send --system --print-reply   \
                --dest=\"org.freedesktop.ConsoleKit\" \
                /org/freedesktop/ConsoleKit/Manager   \
                org.freedesktop.ConsoleKit.Manager.Restart")

    def shutdown_action(self,btn):
        self.disable_buttons()
        os.system(prefix + 'i3-pre-exit')
        os.system("dbus-send --system --print-reply   \
                --dest=\"org.freedesktop.ConsoleKit\" \
                /org/freedesktop/ConsoleKit/Manager   \
                org.freedesktop.ConsoleKit.Manager.Stop")

    def create_window(self):
        self.window = gtk.Window()
        title = "Log out " + getpass.getuser() + "?"
        self.window.set_title(title)
        self.window.set_border_width(5)
        self.window.set_size_request(140, 250)
        self.window.set_resizable(False)
        self.window.set_keep_above(True)
        self.window.stick()
        self.window.set_position(1)
        self.window.connect("delete_event", gtk.main_quit)
        windowicon = self.window.render_icon(gtk.STOCK_QUIT, gtk.ICON_SIZE_MENU)
        self.window.set_icon(windowicon)

        
        #Create HBox for buttons
        self.button_box = gtk.VBox()
        self.button_box.show()
        
        #Cancel button
        self.cancel = gtk.Button(stock = gtk.STOCK_CANCEL)
        self.cancel.set_border_width(4)
        self.cancel.connect("clicked", self.cancel_action)
        self.button_box.pack_start(self.cancel)
        self.cancel.show()

        #Logout button
        self.lock = gtk.Button("_Lock screen")
        self.lock.set_border_width(4)
        self.lock.connect("clicked", self.lock_action)
        self.button_box.pack_start(self.lock)
        self.lock.show()
        
        #Logout button
        self.logout = gtk.Button("Log _out")
        self.logout.set_border_width(4)
        self.logout.connect("clicked", self.logout_action)
        self.button_box.pack_start(self.logout)
        self.logout.show()
        
        #Suspend button
        self.suspend = gtk.Button("_Suspend")
        self.suspend.set_border_width(4)
        self.suspend.connect("clicked", self.suspend_action)
        self.button_box.pack_start(self.suspend)
        self.suspend.show()
        
        #Hibernate button
        self.hibernate = gtk.Button("_Hibernate")
        self.hibernate.set_border_width(4)
        self.hibernate.connect("clicked", self.hibernate_action)
        self.button_box.pack_start(self.hibernate)
        self.hibernate.show()
        
        #Reboot button
        self.reboot = gtk.Button("_Reboot")
        self.reboot.set_border_width(4)
        self.reboot.connect("clicked", self.reboot_action)
        self.button_box.pack_start(self.reboot)
        self.reboot.show()
        
        #Shutdown button
        self.shutdown = gtk.Button("_Power off")
        self.shutdown.set_border_width(4)
        self.shutdown.connect("clicked", self.shutdown_action)
        self.button_box.pack_start(self.shutdown)
        self.shutdown.show()
        
        self.window.add(self.button_box)
        self.window.show()
        
    def __init__(self):
        self.create_window()


def main():
    gtk.main()

if __name__ == "__main__":
    go = i3_exit()
    main()
