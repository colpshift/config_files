#
"""
File: i3_pystatus-config.py / i3pyconfig.py
Author: Colps
Github: https://github.com/colpshift
Description: i3 pystatus configuration file
Last Modified: 14/01/2019 23:43
"""
# https://i3pystatus.readthedocs.io/en/latest/i3pystatus.html#i3
# https://fontawesome.com/cheatsheet?from=io
# https://www.colorhexa.com/e60053
#
# default   gray    color ='#cccccc',
# warning   orange  color ='#ffa500',
# critical  red     color ='#e60053',

from configparser import ConfigParser
from i3pystatus import Status
from i3pystatus import IntervalModule
from i3pystatus.weather import weathercom
from i3pystatus.network import Network
from i3pystatus.network import sysfs_interface_up
from i3pystatus.updates import pacman
from i3pystatus.updates import cower
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

class Online(IntervalModule):
    """    Show internet connection status.    """
    settings = (
        ("color", "Text color when online"),
        ('color_offline', 'Text color when offline'),
        ('format_online', 'Status text when online'),
        ('format_offline', 'Status text when offline'),
        ("interval", "Update interval"),
    )

    def run(self):
        if internet():
            self.output = {
                "color": self.color,
                "full_text": self.format_online,
            }
        else:
            self.output = {
                "color": self.color_offline,
                "full_text": self.format_offline,
            }

# Parser
CONFIG = ConfigParser()
CONFIG.read("/etc/.config_gmail.txt")
GMAILPASS = CONFIG.get("configuration", "password")

STATUS = Status()

# show updates in pacman/aur
STATUS.register(
    "updates",
    format=" {Pacman}/{Cower}",
    backends=[pacman.Pacman(), cower.Cower()],
)

# Show keyboard locks
STATUS.register(
    "keyboard_locks",
    format='{caps} {num}',
    color='#e60053',
    caps_on='Caps On',
    num_on='Num On',
    caps_off='',
    num_off='',
)

# show clock
STATUS.register(
    "clock",
    color='#49edff',
    format=" %a %d/%m  %H:%M",
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
        on_leftclick="firefox --new-tab https://mail.google.com/mail/u/0/#inbox",
        hide_if_null=False,
    )

# Show weather
STATUS.register(
    'weather',
    format='[{icon}] {current_temp}{temp_unit}[ {update_error}]',
    interval=900,
    colorize=True,
    hints={'markup': 'pango'},
    backend=weathercom.Weathercom(
        location_code='BRXX0241:1:BR',
        units='metric',
    )
)

# show/change volume using PA
STATUS.register(
    "pulseaudio",
    format=" {volume}%",
    format_muted=" Mute",
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
    critical_color='#e60053',
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
    color_offline='#e60053',
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
    on_doubleleftclick="termite -e nmcli connection show",
)

# show available memory
STATUS.register(
    "mem",
    color="#cccccc",
    warn_color="ffa500",
    alert_color='#e60053',
    format=" {used_mem} {avail_mem}G",
    warn_percentage=70,
    alert_percentage=90,
    divisor=1024**3,
    on_leftclick="termite -e htop",
)

# show cpu usage
STATUS.register(
    "load",
    critical_color='#e60053',
    format=" {avg1} {avg5} {tasks}",
    on_leftclick="termite -e htop",
)

# show system information
STATUS.register(
    "uname",
    format=' {nodename} {release} ',
    on_leftclick="termite",
)

STATUS.run()
