#!/bin/bash

FILE=/etc/samba/smb.conf
ufwSambaFILE=/etc/ufw/applications.d/samba
ufwSambaRule="[Samba]
title=LanManager-like file and printer server for Unix
description=The Samba software suite is a collection of programs that implements the SMB/CIF$
ports=137,138/udp|139,445/tcp"

#checking if samba is installed
function smbCheck {
	if ! [ -x "$(command -v samba)" ]; then
	  echo 'Error: samba is not installed.' >&2
	  echo 'Install samba using "sudo apt install samba" for debian based system'
	  echo 'For Arch based system use "sudo pacman -S samba" to install'
	  echo 'For Fedora use "sudo dnf install samba"'
	  echo 'Then run this script again!'
	  exit 1
	fi

	echo 'Enabling samba service on startup'

	echo $(sudo systemctl enable smbd nmbd) #for debian based system

	if [ $? -eq 0 ];then
		echo 'samba service enabled!'
	else
		echo $(sudo systemctl enable smb nmb) #most probably for arch based systems
		if [ $? -eq 0 ];then
			echo 'samba service is enabled!'
		else
			echo 'This system might not have a systemd based service.' >&2
			exit 1
		fi
	fi

	echo 'sleeping for 2 seconds'
	sleep 2
}

#creating firewall rules
function createFirewall {
	if ! [ -x "$(command -v ufw)" ]; then
		echo 'Error: ufw firewall is not installed.' >&2
	  	echo 'Install samba using "sudo apt install ufw" for debian based system'
	  	echo 'For Arch based system use "sudo pacman -S ufw" to install'
	  	echo 'For Fedora use "sudo dnf install ufw"'
	  	echo 'Then run this script again! As you are not supposed to run samba without firewall!'
	  	exit 1
	else
		echo 'Allowing samba in firewall rules'
		ufw allow samba
		if [ $? -eq 0 ];then
			echo 'Added rule to firewall'
		else
			echo 'Adding samba to /etc/ufw/applications.d/samba'
			touch "$ufwSambaFILE"
			echo "$ufwSambaRule" >> "$ufwSambaFILE"
			echo 'Allowing samba in firewall rules, AGAIN!'
			ufw allow samba
			echo 'Added rule to firewall, FINALLY!'
		fi
	fi
}

#checking if /etc/samba exists, if not then create one!
function createSMBDirectory {
	if ! [ -d "/etc/samba" ];then
		echo 'Directory /etc/samba does not exist!! Creating...'
		cd /etc; mkdir samba; cd samba
	fi
}

#switch case for creating new or editing existing smb.conf
function createSMBConf {
	read -p "Do you want to create a new smb.conf file (type y) or edit the existing one?(type n): "
	#read action

	case ${REPLY} in
		"y")if ! [ -f "$FILE" ];then
				echo 'smb.conf file not found in /etc/samba! Creating...'
				touch "$FILE"
			else
				echo 'creating smb.conf.bkp and creating new smb.conf in /etc/samba'
				mv "$FILE" /etc/samba/smb.conf.bkp
				touch "$FILE"
				ls -lrt /etc/samba
			fi
			#now the real fun begins... editing the smb.conf file
			echo 'opening smb.conf... to write to the file press ctrl+w, then ctrl+x to exit editing'
			sleep 5
			nano "$FILE"
		;;
		"n")if [ -f "$FILE" ];then
				echo 'opening smb.conf... to write to the file press ctrl+w. ctrl+x to exit editing'
				sleep 5
				nano "$FILE"
			else
				echo 'smb.conf file not found!'
				createSMBConf
			fi
		;;
		*)echo 'wrong option entered!'
			createSMBConf
		;;
	esac
}

#restarting samba service
function restartSMBService {
	echo 'Restarting samba service...'
	systemctlMessage1=`systemctl restart smbd nmbd`
	if [[ $systemctlMessage1 == *"Failed"* ]];then
		echo 'output: '$systemctlMessage1
	else
		echo 'output: '$systemctlMessage1
	fi
	systemctlMessage2=`systemctl restart smb nmb`
	if [[ $systemctlMessage2 == *"Failed"* ]];then
		echo 'output: '$systemctlMessage2
	else
		echo 'output: '$systemctlMessage2
	fi
}

#adding samba user and password using smbpasswd
function createSMBUser {
	echo 'Now setting up samba user and password....'
	read -p 'Enter username: '
	#read user
	smbpasswd -a ${REPLY}
}

smbCheck
createFirewall
createSMBDirectory
createSMBConf
restartSMBService
createSMBUser


echo 'Samba profile and share creation completed!!'
