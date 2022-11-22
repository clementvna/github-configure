#!/bin/bash

clear

# Introduces a pause function
function pause() {
	read -p "$*"  -n 1 -r
}

echo 'Welcome to GitHub !'
sleep 3
clear

# Installs Git for Linux if not already
echo 'Installing Git...'
sudo apt-get install -y git >> /dev/null
clear

# Prompts user to choose an username for Git
read -p 'Choose an username for Git : ' GIT_USER
# Sets the default name for git to use when you commit
git config --global user.name $GIT_USER
clear

# Prompt user to choose an email address for Git
read -p 'Choose an email for Git : ' GIT_EMAIL
# Sets the default email for git to use when you commit
git config --global user.email $GIT_EMAIL
clear

# Set git to use the credential memory cache
# Set the cache to timeout after $PW_TIMEMOUT seconds
read -p 'Do you want to use password cache ? (y/n) ' -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	git config --global credential.helper cache
	read -p 'Choose a password timeout (in seconds): ' PW_TIMEOUT
	clear
	git config --global credential.helper 'cache --timeout=$PW_TIMEOUT'
	clear
fi

# Prompt the user to use SSH with GitHub
read -p 'Do you want to use SSH connection with GitHub (advanced users) ? (y/n) ' -n 1 -r
echo
clear

# Check if "/home/$USER/.ssh" folder exists
# If not, it creates the folder
# Creates a new ssh key, using the provided email as a label
if [[ $REPLY =~ ^[Yy]$ ]]; then
	clear
	if [ ! -d '/home/$USER/.ssh' ]; then
   		mkdir ~/.ssh
	fi

	cd /home/$USER/.ssh

    	echo '***************************************************************************************************************'
	echo 'You will be prompted to choose a passphrase.'
	echo 'Recommended: choose a strong passphrase with alphanumerical characters, different cases and special characters.'
	echo 'Not recommended: you can leave this field empty for no passphrase.'
	echo '***************************************************************************************************************'
	pause 'Once you read this advice, press any key to continue.'
	echo
	clear

   	ssh-keygen -t rsa -C $GIT_MAIL

   	clear

	# Generating public/private rsa key pair
	# Enter file in which to save the key (/home/$USER/.ssh/id_rsa):
	echo '***************************************************************************************************************'
	echo 'You will be prompted to choose a passphrase.'
	echo 'Recommended: choose a strong passphrase with alphanumerical characters, different cases and special characters.'
	echo 'Not recommended: you can leave this field empty for no passphrase.'
	echo '***************************************************************************************************************'
	pause 'Once you read this advice, press any key to continue.'
	echo
	clear
	ssh-add id_rsa
	clear

	# Download and install xclip. If you don't have `apt-get`, you might need to use another package manager (like `yum`)
	echo 'Installing xclip...'
	sudo apt-get install -y xclip >> /dev/null

	# Copies the contents of the id_rsa.pub file to your clipboard
	xclip -sel clip < /home/$USER/.ssh/id_rsa.pub

	clear

	# Instructions to add SSH Key to GitHub account
	echo 'The generated SSH key is now copied into the clipboard'
	echo '1) Login to GitHub website'
	echo '2) Go to your <Account Settings>'
	echo '3) Click <SSH Keys> in the left sidebar'
	echo '4) Click "Add SSH key'
	echo '5) Paste your key into the <Key> field'
	echo '6) Click <Add key>'
	echo '7) Confirm the action by entering your GitHub password'
	echo
	pause 'Once everything above is done, press any key to continue.'
	echo
	clear

	# Testing the SSH connection with GitHub
	read -p 'Do you want to use SSH connection with GitHub ? (y/n) ' -n 1 -r
	echo
	echo '********************************************************************************************************************************************'
	echo 'HELP'
	echo
	echo 'Firts case, you see <Permission denied (public key):'
	echo 'This is a known problem with certain Linux distributions.'
	echo 'More informations here: <https://help.github.com/articles/error-agent-admitted-failure-to-sign>'
	echo
	echo 'Second case, you see this answer <Are you sure you want to continue connecting (yes/no)?>'
	echo 'Do not worry, this is supposed to happen. Verify that the fingerprint matches the one here and type <yes>.'
	echo
	echo 'Third case, you see again <Access denied>'
	echo 'If you see "access denied" please consider using HTTPS instead of SSH. If you need SSH start at these instructions for diagnosing the issue.'
	echo '********************************************************************************************************************************************'
	if [[ $REPLY =~ ^[Yy]$ ]]; then
   	 echo
		echo 'Testing SSH connection to GitHub...'
		echo
		sleep 2
		# Attempt to SSH to github
		ssh -T git@github.com
		echo
		echo 'If that your username is correct, you have successfully set up your SSH key. Do not worry about the shell access thing, you do not want that anyway.'
		pause 'Press any key to continue.'
	   clear
	fi

	# Prompt the user for xclip to be removed if he chooses to
	read -p 'Optional: do you want the previously installed package xclip to be removed (only used to copy the SSH key directly from file to clipboard) ? (y/n) ' -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		clear
		echo 'Removing xclip...'
		sudo apt-get purge -y xclip* >> /dev/null
	fi
fi

clear
echo 'GitHub configuration successfully terminated !'
sleep 3
clear
exit 0
