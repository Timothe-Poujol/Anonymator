#!/bin/bash
# Anonymise yourself
sudo echo ""

#Regular colors
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
WHITE='\e[0;37m'
#Bold colors
BRED='\e[1;31m'
BGREEN='\e[1;32m'
BBLUE='\e[1;34m'
BWHITE='\e[1;37m'
#Others colors

Interface=$(ip route list | grep default | awk '{print $5} ')
Old_mac=$(cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/address)
Old_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)



#Pause the script when ou need to
function pause()
{
  echo -e "${BWHITE}Press [Enter] key to continue...${WHITE}"
   read -p "$*"
}
#A fonction to start torghost
TorGhost ()
{
  echo -e "${BWHITE}Starting torghost"
  echo ""
  echo "torghost output:"
  sudo torghost start
  echo ""
  echo "Your IP adress is now hidden"
  echo -e " Remember: If you want to cut torghost, type: ${BRED}sudo torghost stop${WHITE}"
  echo "(You can also reboot)"
  pause
}

#A fonction to change the mac adress with macchanger
spoof_mac ()
{
          echo -e "${BWHITE}Disabling network services"
          sudo systemctl stop NetworkManager
          echo ""
          echo "Changing mac adress"
          (sudo macchanger -A $(echo $Interface)
          )> /dev/null 2>&1
          echo ""
          echo "Rebooting network services"
          sudo systemctl start NetworkManager
          echo ""
          echo -e "Waiting to the network to reboot properly...${WHITE}(15s)"
          sleep 15s
}

#Test the internet conexion and save it to a variable
internet_test ()
{
  Network=$(ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo ok || echo error)
  if [ $Network = ok ]
  then
    Net_status=1
  else
    Net_status=2
  fi
}

#Just a litle loop to another fonction to avoid infinite loops
internet_loop ()
{
  if [ $Net_status = "1" ]
  then
    echo ""
  else
    Internet_loss
  fi
}


#Troubleshoot internet issues
Internet_loss ()
{
  echo -e "${BRED} Oh no! Internet is not working...${BWHITE} I will try to fix the bug and reverting changes...${WHITE}"
                      pause
                      echo ""
                      sudo torghost stop
                      sudo ifconfig $(echo $Interface) down
                      sudo service network-manager stop
                      sudo macchanger -p $(echo $Interface)
                      sudo service network-manager start
                      sudo ifconfig $(echo $Interface) up
                      sleep 15s
                      internet_test


  if [ $Net_status = "1" ]

    then
      echo -e "${GREEN}Internet is back, but you are not anonymous${WHITE}"

    elif [ $Net_status = "2" ]
    then
      echo -e "${BRED}Oh no! I can't bring internet back... You need to reboot to fix this issue...${BWHITE}"
      echo "Do you want to reboot? (y/n)"
      read -p "Your Choice: " Reboot_choice
        if [ $Reboot_choice = "y" ]
          then
            reboot
          else
          echo "Okay, don't forget to reboot later!"
          echo "Keep in mind that you are not anonymous!${WHITE}"
        fi
    else
      echo ""
  fi
}


#A fonction to show your ip adress and mac adress
informations ()
{
  New_mac=$(cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/address)
  New_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
  clear
  echo ""
  echo -e "${BWHITE}You are now anonymous! :)"
  echo -e "Here is all the info you need:"
  echo ""
  echo -e "${BGREEN}ACTUAL mac adress:${BBLUE}"
  echo $New_mac
  echo -e "${BGREEN}OLD mac adress:${BBLUE}"
  echo $Old_mac
  echo ""
  echo -e "${BGREEN}ACTUAL ip adress: ${BBLUE}"
  echo $New_IP
  echo -e "${BGREEN}OLD ip adress: ${BBLUE}"
  echo $Old_IP
  echo -e "Check it here!: ${BWHITE}https://duckduckgo.com/ip${WHITE} (ctrl + click)"
  echo ""
  echo -e "${WHITE}"
  pause
}




clear
echo -e "${BRED} _____                           _            "
echo          "|  _  |___ ___ ___ _ _ _____ ___| |_ ___ ___  "
echo          "|     |   | . |   | | |     | .'|  _| . |  _| "
echo          "|__|__|_|_|___|_|_|_  |_|_|_|__,|_| |___|_|   "
echo -e       "                  |___|                       "
echo -e "                    ${BBLUE}Made with <3 From France${BWHITE}"
echo -e "1: Spoof your mac adress"
echo "2: Reroute all your conexions throug tor (Unstable)"
echo "3: Do both (Unstable)"
echo -e "4: Install dependencies (you need to do it once)${BBLUE}"


#Declaring variables
read -p "Your Choice: " C
clear



#Menu in the console
if [ $C = "1" ]
then
          spoof_mac
          internet_test
          internet_loop
          informations


elif [ $C = "2" ]
then
          TorGhost
          internet_test
          internet_loop
          informations


elif [ $C = "3" ]
then
            spoof_mac
            TorGhost
            internet_test
            internet_loop
            informations


elif [ $C = "4" ]
then
          clear
          echo -e "${BWHITE}Downloading and installing tor"
          (sudo apt-get install tor -y
          )> /dev/null 2>&1
          echo ""
          echo "Downloading and installing macchanger"
          sudo apt-get install macchanger -y
          echo ""
          echo "Downloading and installing python pip"
          echo "(+/- 28MB + dependencies) -> Can take some time"
          (sudo apt-get install python-pip -y
          )> /dev/null 2>&1
          echo ""
          echo "Downloading and installing stem"
          echo "(+/- 10MB) -> Can take some time"
          (sudo pip2 install steam
          )> /dev/null 2>&1
          echo ""
          echo "Downloading Torghost"
          (git clone https://github.com/susmithHCK/torghost.git
          )> /dev/null 2>&1
          echo ""
          echo "Installing Torghost"
          (cd torghost
          chmod +x install.sh
          sudo ./install.sh
          cd ..
          sudo rm -rf torghost
          )> /dev/null 2>&1
          echo ""
          echo "Installing net-tools"
          echo ""
          (sudo apt install net-tools
          )> /dev/null 2>&1
          echo "Installing NetworkManager"
          echo ""
          (sudo apt-get install network-manager
          )> /dev/null 2>&1
          echo -e "${BGREEN}All dependencies installed!"
          echo ""
          echo "Restart the script to use it! :)"
else
          echo -e "${BRED}Wrong entry${BWHITE}"
fi
