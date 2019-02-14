#
"""
File: i3_pystatus-config.py / i3pyconfig.py
Author: Colps
Github: https://github.com/colpshift
Description: i3 pystatus configuration file
Last Modified: 11/02/2019 02:14
"""
# https://i3pystatus.readthedocs.io/en/latest/i3pystatus.html#i3
# https://fontawesome.com/cheatsheet?from=io
# https://www.colorhexa.com/e60053
#
# color     green   color ='#00e620',
# default   gray    color ='#cccccc',
# warning   orange  color ='#ffa500',
# critical  red     color ='#ff0000',

from configparser import ConfigParser
from i3pystatus import Status
from i3pystatus.network import Network, sysfs_interface_up
from i3pystatus.online import Online
from i3pystatus.core.util import internet
from i3pystatus.mail import imap

class MyNetwork(Network):
    """
    Modified Network class that automatic switch interface in case of
    the current interface is down.
    """
    on_upscroll = None
    on_downscroll = None
    color = '#cccccc'

    def run(self):
        super().run()
        if not sysfs_interface_up(self.interface, self.unknown_up):
            self.cycle_interface()

# Parser
CONFIG = ConfigParser()
CONFIG.read("/etc/.config_gmail.txt")
GMAILPASS = CONFIG.get("configuration", "password")

STATUS = Status()

# show clock
STATUS.register(
    "clock",
    color='#49edff',
    format=" %d/%m/%y  %k:%M",
    on_leftclick = "firefox --new-tab https://calendar.google.com/calendar/r",
)

# check email
if internet():
    STATUS.register(
        "mail",
        backends=[imap.IMAP(
            host="imap.gmail.com",
            username="marcos.colpani@gmail.com",
            password=GMAILPASS)],
        color='#cccccc',
        color_unread='#ffa500',
        format=" {unread}",
        on_leftclick="tilix -e neomutt",
        #on_leftclick="i3-msg workspace 9 && tilix -e neomutt",
        hide_if_null=False,
    )

# show/change volume using PA
STATUS.register(
    "pulseaudio",
    format=" {volume}%",
    format_muted=" Mute",
)

# show backlight %
STATUS.register(
    "backlight",
    base_path="/sys/class/backlight/intel_backlight/",
    format=" {percentage}%",
)

# show battery status
STATUS.register(
    'battery',
    format="[{status} ]{remaining}",
    interval=5,
    alert=True,
    alert_percentage=15,
    color='#ffa500',
    charging_color='#00e620',
    critical_color='#ff0000',
    full_color='#cccccc',
    status={
        "CHR": "",
        "DPL": "",
        "DIS": "",
        "FULL": "",
    },
)

# internet status
STATUS.register(
    Online,
    color='#00e620',
    color_offline='#ff0000',
    format_online="",
    format_offline="",
    interval=10,
)

# show network speed
STATUS.register(
    MyNetwork,
    format_up="{interface:.6}  {bytes_recv}K  {bytes_sent}K",
    format_down="{interface:.6} ",
    interface="enp3s0",
    on_doubleleftclick="tilix -e nmcli connection show",
)

# show available memory
STATUS.register(
    "mem",
    color="#cccccc",
    warn_color="ffa500",
    alert_color='#ff0000',
    format=" {used_mem} {avail_mem}G",
    warn_percentage=70,
    alert_percentage=90,
    divisor=1024**3,
    on_leftclick="tilix -e htop",
)

# show cpu usage
STATUS.register(
    "load",
    critical_color='#ff0000',
    format=" {avg1} {avg5} {tasks}",
    on_leftclick="tilix -e htop",
)

# show system information
STATUS.register(
    "uname",
    format='{nodename} {release}',
    on_leftclick="neofetch",
)

# Show keyboard locks
STATUS.register(
    "keyboard_locks",
    format='{caps} {num}',
    color='#ff0000',
    caps_on='Caps On',
    num_on='Num On',
    caps_off='',
    num_off='',
)

STATUS.run()
