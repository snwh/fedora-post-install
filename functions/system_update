#!/bin/bash

# Perform system upgrade via dnf
function update_system {
	echo_message title "Performing system update..."
	# Draw window
	if (whiptail --title "System Update" --yesno "Check for system software updates?" 8 56) then
		# Check if there are updates
		if [[ "$(echo $(dnf check-update -q | wc -l ))" -gt 0 ]]; then
			# Draw window
			if (eval `resize` && whiptail \
				--title "System Update" \
				--yesno "Current list of packages to be updated: \n\n$(dnf list -q --updates) \n\nAre you sure you want proceed?" \
				$LINES $COLUMNS $(( $LINES - 12 )) \
				--scrolltext ) then
				# Admin privileges
				superuser_do "dnf update -y"
				# Check if failed
				if [[ $? != 0 ]]; then
					echo_message info "Nothing to update."
					whiptail --title "Finished" --msgbox "Nothing to update." 8 56
					main
				fi
				# Finished
				echo_message success "System update complete."
				whiptail --title "Finished" --msgbox "System update complete." 8 56
				main
			else
				# Cancelled
				echo_message info "System update cancelled."
				main
			fi
		else
			# If no updates are available
			echo_message info "No updates available."
			whiptail --title "Finished" --msgbox "No updates are available." 8 56
			main
		fi
	else
		# Cancelled
		echo_message info "System update cancelled."
		system_update
	fi
}

# Check for flatpak updates
function update_flatpak_apps {
	# check if flatpak is installed
	check_package "flatpak" system_update
	# continue
	echo_message info "Updating installed flatpak packages..."
	flatpak update
	if [ $? = 0 ]; then
		# Finished
		echo_message success "All flatpaks up to date."
		whiptail --title "Finished" --msgbox "All flatpaks up to date." 8 56
		system_update
	else
		# Finished
		echo_message success "Flatpak package update complete."
		whiptail --title "Finished" --msgbox "Flatpak package update complete." 8 56
		system_update
	fi
}

# Perform system updates
function system_update {
	# install
	echo_message title "Starting system updates..."
	# Draw window
	UPDATE=$(eval `resize` && whiptail \
		--notags \
		--title "Install $NAME" \
		--menu "\nWhat ${NAME,,} would you like to install?" \
		--ok-button "Install" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(( $LINES - 12 )) \
		'update_system'         'Check for system updates' \
		'update_flatpak_apps'   'Check for Flatpak updates' \
		3>&1 1>&2 2>&3)

	# check exit status
	if [ $? = 0 ]; then
		echo_message header "Starting '$UPDATE' function..."
		$UPDATE
	else
		# Cancelled
		echo_message info "System updates cancelled."
		main
	fi
}