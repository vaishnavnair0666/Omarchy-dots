## pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103
# pylint settings included to disable linting errors ========================
# Imports
# ========================
import catppuccin
import subprocess
from qutebrowser.api import config, message

# ========================
# General
# ========================
config.load_autoconfig(False)  # don’t load auto-generated defaults

c.auto_save.session = True      # restore previous session
c.scrolling.smooth = True
c.confirm_quit = ["downloads"]  # don’t nag when closing unless downloading
c.content.autoplay = False      # block autoplay videos
c.content.notifications.enabled = False

# ========================
# Privacy & Security
# ========================
c.content.blocking.method = "adblock"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
]

# Disable fingerprinting surface
c.content.webgl = False
c.content.canvas_reading = False
c.content.geolocation = False

# ========================
# Performance / RAM
# ========================
c.content.cache.size = None
c.content.javascript.enabled = True  # default on for dev
c.content.cookies.accept = "all"     # allow cookies for logins
c.tabs.background = True

# ========================
# Appearance
# ========================
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.fonts.default_size = "12pt"

c.tabs.position = "top"
c.tabs.show = "multiple"
c.statusbar.show = "always"

c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'
config.set('colors.webpage.darkmode.enabled', False, 'file://*')

# Example: Catppuccin Mocha
catppuccin.setup(c, 'mocha', True)
c.statusbar.widgets = ["keypress", "url", "scroll", "progress", "history", "tabs", "keypress", "perdomain", "text:js", "text:cookies"]
def _js_status():
    return "JS: ON" if c.content.javascript.enabled else "JS: OFF"

def _cookie_status():
    mode = c.content.cookies.accept
    return f"Cookies: {mode}"

config.val.statusbar.widgets.append(("text", _js_status))
config.val.statusbar.widgets.append(("text", _cookie_status))
# ========================
# QOL
# ========================
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    '!aw': 'https://wiki.archlinux.org/?search={}',
    '!apkg': 'https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged=',
    '!gh': 'https://github.com/search?o=desc&q={}&s=stars&type=Repositories',
    '!ghu': 'https://github.com/users/{}/repos?type=owner&sort=updated',
    '!yt': 'https://www.youtube.com/results?search_query={}',
}

c.completion.open_categories = [
    'searchengines', 'quickmarks', 'bookmarks', 'history', 'filesystem'
]

# ========================
# Keybindings
# ========================
config.bind('=', 'cmd-set-text -s :open')
config.bind('h', 'history')
config.bind('cs', 'cmd-set-text -s :config-source')
config.bind('tH', 'config-cycle tabs.show multiple never')
config.bind('sH', 'config-cycle statusbar.show always never')
config.bind('T', 'hint links tab')
config.bind('pP', 'open -- {primary}')
config.bind('pp', 'open -- {clipboard}')
config.bind('pt', 'open -t -- {clipboard}')
config.bind('qm', 'macro-record')
config.bind('<ctrl-y>', 'spawn --userscript ytdl.sh')
config.bind('tT', 'config-cycle tabs.position top left')
config.bind('gJ', 'tab-move +')
config.bind('gK', 'tab-move -')
config.bind('gm', 'tab-move')

config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("<Ctrl-d>", "scroll-page 0 0.5")
config.bind("<Ctrl-u>", "scroll-page 0 -0.5")

# Open external apps
config.bind(",m", "spawn mpv {url}")          # play video in mpv
config.bind(",d", "spawn yt-dlp {url}")       # download video
config.bind(",e", "spawn -d nvim {url}")      # open page in neovim (via curl)

# Toggles
config.bind(",j", "config-cycle content.javascript.enabled true false")
config.bind(",c", "config-cycle content.cookies.accept all no-3rdparty never")
