#!/bin/sh
# This script is to install all software after Fedora is installed.
# Written by Philip R. Simonson
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# Function : Install an application.
# Arguments: Application name given.
# Exit on error.
# ------------------------------------------------------------------
install_app() {
	if [[ $# -lt 1 || $# -gt 2 ]]; then
		echo "Usage: $0 <app|group> <app-name>"
		exit 1
	fi

	if [[ "$#" = "2" && "$1" = "app" ]]; then
		sudo dnf install "$2" -y
		if [ ! "$?" = "0" ]; then
			echo "$2: failed to install."
			exit 1
		fi
	elif [[ "$#" = "2" && "$1" = "grp" ]]; then
		sudo dnf group install "$2" -y
		if [ ! "$?" = "0" ]; then
			echo "$2: failed to install."
			exit 1
		fi
	else
		sudo dnf install "$1" -y
		if [ ! "$?" = "0" ]; then
			echo "$1: failed to install."
			exit 1
		fi
	fi
}

if [ ! "$#" = "0" ]; then
	echo "Usage: $0"
	exit 1
fi

# Get packages.txt from server.
wget https://github.com/psimonson/fedora-post/blob/master/packages.txt
if [ ! "$?" = "0" ]; then
	echo "Error: Failed to get package list."
	exit 1
fi

# Main program starts here.
sudo dnf update -y
while read -r line
do
	install_app "$line"
done < <(cat packages.txt)
install_app grp "Development Tools"
install_app grp "Development Libraries"
