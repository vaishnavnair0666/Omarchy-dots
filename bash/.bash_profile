#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -e /home/vaish/.nix-profile/etc/profile.d/nix.sh ]; then . /home/vaish/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
