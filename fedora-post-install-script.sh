#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <hewittsamuel@gmail.com>
#
# Description:
#   A post-installation bash script for Fedora
#
# Legal Stuff:
#
# This script is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; version 3.
#
# This script is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/gpl-3.0.txt>

clear
echo ''
echo '#-------------------------------------#'
echo '#     Fedora Post-Install Script      #'
echo '#-------------------------------------#'

#----- FUNCTIONS -----#

. functions/cleanup
. functions/codecs
. functions/config
. functions/customize
. functions/design
. functions/development
. functions/drivers
. functions/favourites
. functions/gnome
. functions/repos
. functions/system
. functions/themes
. functions/thirdparty
. functions/upgrade

#----- MAIN FUNCTIONS -----#

# Quit
function quit {
read -p "Are you sure you want to quit? (Y)es, (N)o " REPLY
case $REPLY in
    [Yy]* ) exit 99;;
    [Nn]* ) clear && main;;
    * ) clear && echo 'Sorry, try again.' && quit;;
esac
}

#----- MAIN FUNCTION -----#
function main {
echo ''
echo '1. Perform system update & upgrade?'
echo '2. Install favourite applications?'
echo '3. Install favourite system utilities?'
echo '4. Install development tools?'
echo '5. Install design tools?'
echo '6. Install third-party applications?'
echo '7. Install extra GNOME applications?'
echo '8. Install media playback codecs?'
echo '9. Install drivers?'
echo '10. Configure repositories?'
echo '11. Configure system?'
echo '12. Cleanup the system?'
echo 'q. Quit?'
echo ''
read -p 'What would you like to do? (Enter your choice) : ' REPLY
case $REPLY in
    1) clear && upgrade;; # System Upgrade
    2) clear && favourites;; # Install Favourite Applications
    3) clear && utilities;; # Install Favourite Tools
    4) clear && development;; # Install Dev Tools
    5) clear && design;; # Install Design Tools
    6) clear && thirdparty;; # Install Third-Party Applications
    7) clear && gnome;; # Install Extra GNOME Applications
    8) clear && codecs;; # Install Third-Party Applications
    9) clear && drivers;; # Install Drivers
    10) clear && repos;; # Configure Repositories
    11) clear && config;; # Configure system
    12) clear && cleanup;; # Cleanup System
    [Qq]* ) echo '' && quit;; # Quit
    * ) clear && echo 'Not an option, try again.' && main;;
esac
}

#----- RUN MAIN FUNCTION -----#
main

#END OF SCRIPT
