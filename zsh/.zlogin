# .zlogin, read as last file for login shells.

# case $TTY in
#  /dev/tty[789])
#     exec startx -- vt${TTY#/dev/tty}
# esac

# Dead Simple Display Manager: on tty1 run X if running the default kernel.
if [ "$(tty)" = /dev/tty1 ]; then  # && grep -q resume /proc/cmdline; then
  dpy=0
  while xdpyinfo -display :$dpy &>/dev/null; do
    dpy=$((dpy+1))
  done
  startx -- :$dpy &!
  logout
fi
