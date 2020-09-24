# easySMB

easySMB is a program that let's you setup samba shares when the default samba share isn't working from a distro (t is a common problem when one wants to setup samba share and it doesn't show up or detect in the network). This script will enable you to create your own, customizable samba shares for your drives, folders, printers, etc so that you don't have to beat around the bush in order to completely setup samba correctly.

### Disclaimer

This script is not for the faint of heart. Use it at your own risk! You should not run any script without reading the contents of the script first! Firstly, you need to have a little bit of shell scripting knowledge beforehand(if you don't please don't run this script as i will not be held responsible for crashing your system!).

This script still needs a lot of work. If you donot want to run a particular function in this script then comment it, save and run.

<strong> You have to use systemd as you default system and service manager. I don't have any idea about other services(yet).</strong>

This script will do the following steps:

 * Check whether you have installed samba in your system or not.
 * If samba found then enable it on startup in systemd.
 * Will check whether you have firewalld(gufw) installed or not.
 * Enable samba in firewall and set rule as "Allow".
 * Check for /etc/samba directory, if not found will create one.
 * Check for existing smb.conf in /etc/samba directory. If not found then create one, provides an option to create a new smb.conf file or backup existing smb.conf to smb.conf.bkp and then create a new smb.conf file, which will open in nano editor in terminal.
 * You will find a sample smb.conf file in <a href="https://github.com/VigilantLoki119/easySMB/tree/master/smb.conf_sample">here</a>. 
 * If you want to use default settings with no password protection then copy the contents of this file and paste it inside the opened nano editor. Then ctrl+s to save and ctrl+x to exit.
 * Samba service will restarted in systemd for changes to take place.
 * A new samba user will be created where you will be prompted to enter a username(preferable to use your system username) and an smb password. 
 * Your samba setup will be completed. Check in your network whether you can find the shares.

 ## Usage

<strong>To run this script you will have to be superuser, otherwise each and everyline of this script will fail.</strong>

```bash
sudo ./easySMB.sh
```
To check whether you have samba installed

```bash
which samba
```
This will return a bin directory for samba. If it returns blank then install samba.

* Ubuntu/Debian based system
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install samba
```

* Fedora systems
```bash
sudo dnf upgrade
sudo dnf install samba
```
* Arch based systems
```bash
sudo pacman -Syyu
sudo pacman -S samba
```

If you have gufw installed then great! The script will do the rest for you. If not then:

* Ubuntu/Debian based system
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install gufw
sudo systemctl enable ufw
sudo ufw enable #this will enable the firewall for your system and add itself in systemd's startup
```

* Fedora systems
```bash
sudo dnf upgrade
sudo dnf install ufw
sudo systemctl enable ufw
sudo ufw enable #this will enable the firewall for your system and add itself in systemd's startup
```
* Arch based systems
```bash
sudo pacman -Syyu
sudo pacman -S ufw
sudo systemctl enable ufw
sudo ufw enable #this will enable the firewall for your system and add itself in systemd's startup
```
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Also I would be happy to allow contributors to contribute to this. As I would really need some!

## License
<a href="https://github.com/VigilantLoki119/easySMB/blob/master/LICENSE">GNU General Public License v3.0</a>
