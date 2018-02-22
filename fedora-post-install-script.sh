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

. $dir/functions/check
. $dir/functions/cleanup
. $dir/functions/codecs
. $dir/functions/configure
. $dir/functions/development
. $dir/functions/faves
. $dir/functions/password
. $dir/functions/node_apps
. $dir/functions/repos
. $dir/functions/thirdparty
. $dir/functions/update
. $dir/functions/utilities

# Fancy colorful echo messages
function echo_message(){
	local color=$1;
	local message=$2;
	if ! [[ $color =~ '^[0-9]$' ]] ; then
		case $(echo -e $color | tr '[:upper:]' '[:lower:]') in
			# 0 = black
			title) color=0 ;;
			# 1 = red
			error) color=1 ;;
			# 2 = green
			info) color=2 ;;
			# 3 = yellow
			warning) color=3 ;;
			# 4 = blue
			question) color=4 ;;
			# 5 = magenta
			success) color=5 ;;
			# 6 = cyan
			header) color=6 ;;
			# 7 = white
			*) color=7 ;;
		esac
	fi
	tput bold;
	tput setaf $color;
	echo "-- $message";
	tput sgr0;
}

# Main
function main {
	echo_message title "Starting 'main' function"
	eval `resize`
	MAIN=$(whiptail \
		--notags \
		--title "Fedora Post-Install Script" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Quit" \
		$LINES $COLUMNS $(( $LINES - 12 )) \
		update			'Perform system update' \
		faves			'Install preferred applications' \
		utilities		'Install preferred CLI utilities' \
		development		'Install preferred development tools' \
		codecs			'Install multimedia codecs' \
		node_apps		'Install NodeJS-based tools' \
		thirdparty		'Install third-party applications' \
		repositories	'Add third-party repositories' \
		configure		'Configure system' \
		cleanup			'Cleanup the system' \
		3>&1 1>&2 2>&3)
	 
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
		$MAIN
	else
		echo_message info 'Quitting...'
		quit
	fi
}

# Quit
function quit {
	echo_message title "Starting 'quit' function"
	# Draw window
	if (whiptail --title "Quit" --yesno "Are you sure you want quit?" 10 60) then
		echo "Exiting..."
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