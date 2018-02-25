#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <sam@snwh.org>
#
# Description:
#   A post-installation bash script for Fedora
#
# Legal Preamble:
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

# tab width
tabs 4
clear

#----- Import Functions -----#

dir="$(dirname "$0")"

. $dir/functions/checks
. $dir/functions/cleanup
. $dir/functions/codecs
. $dir/functions/configure
. $dir/functions/installation
. $dir/functions/gnome
. $dir/functions/password
. $dir/functions/repos
. $dir/functions/thirdparty
. $dir/functions/update

# Fancy colorful echo messages
function echo_message(){
	local color=$1;
	local message=$2;
	if ! [[ $color =~ '^[0-9]$' ]] ; then
		case $(echo -e $color | tr '[:upper:]' '[:lower:]') in
			# black
			title) color=0 ;;
			# red
			error) color=1 ;;
			# green
			success) color=2 ;;
			# yellow
			warning) color=3 ;;
			# blue
			header) color=4 ;;
			# magenta
			info) color=5 ;;
			# cyan
			question) color=6 ;;
			# white
			*) color=7 ;;
		esac
	fi
	tput bold;
	tput setaf $color;
	echo '-- ' $message;
	tput sgr0;
}

# Main
function main {
	echo_message title "Starting 'main' function"
	MAIN=$(eval `resize` && whiptail \
		--notags \
		--title "Fedora Post-Install Script" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Quit" \
		$LINES $COLUMNS $(( $LINES - 12 )) \
		update			'Perform system update' \
		install_favs	'Install preferred applications' \
		install_utils	'Install preferred utilities' \
		install_dev		'Install preferred development tools' \
		install_gnome	'Install additional GNOME software' \
		install_codecs	'Install multimedia codecs' \
		thirdparty		'Install third-party applications' \
		repositories	'Add third-party repositories' \
		configure		'Configure system' \
		cleanup			'Cleanup the system' \
		3>&1 1>&2 2>&3)

	# Check if fails
	if [ $? = 0 ]; then
		$MAIN
	else
		quit
	fi
}


# Quit
function quit {
	echo_message title "Starting 'quit' function"
	# Draw window
	if (whiptail --title "Quit" --yesno "Are you sure you want quit?" 10 60) then
		echo_message info "Exiting..."
		echo_message header 'Thanks for using!'
		exit 99
	else
		main
	fi
}

# Welcome message
echo_message header "Fedora Post-Install Script"
# Run check
check

#RUN
while :
do
  main
done

#END OF SCRIPT