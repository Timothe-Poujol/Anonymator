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
Old_IP=$(wget -qO - v4.ifconfig.co)



#Pause the script when you need to
function pause()
{
  echo -e "${BWHITE}Press [Enter] key to continue...${WHITE}"
   read -p "$*"
}

#A fonction to spoof the mac adress with macchanger
function spoof_mac ()
{
          echo -e "${BWHITE}Disabling network services"
          sudo systemctl stop NetworkManager
          echo ""
          echo -e "${BBLUE}Changing mac adress${BWHITE}"
          (sudo macchanger -A $(echo $Interface)
          )> /dev/null 2>&1
          echo ""
          echo "Rebooting network services"
          sudo systemctl start NetworkManager
          echo ""
          echo -e "Waiting to the network to reboot properly...${WHITE}(can take some time)"
          sleep 11s
}

#Reroute all internet trafic throug tor
function tor_iptables2 ()
{
        echo ""
        echo -e "${BWHITE}Changing iptables rules to ${BBLUE}reroute all trafic throug tor${WHITE}"
        cd toriptables2
        (sudo python toriptables2.py -l
        )> /dev/null 2>&1
        cd ..
}

#Test the internet conexion and save it to a variable
function internet_test ()
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
function internet_loop ()
{
  if [ $Net_status = "1" ]
  then
    echo ""
  else
    Internet_loss
  fi
}


#Troubleshoot internet issues
function Internet_loss ()
{
  echo -e "${BRED} Oh no! Internet is not working...${BWHITE} I will try to fix the bug and reverting changes...${WHITE}"
                      pause
                      echo ""
                      echo ""
                      cd toriptables2
                      (sudo python toriptables2.py -f
                      )> /dev/null 2>&1
                      cd ..                      sudo ifconfig $(echo $Interface) down
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
function informations ()
{
  New_mac=$(cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/address)
  New_IP=$(wget -qO - v4.ifconfig.co)
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
  echo -e "$New_IP|Check it here!: ${BWHITE}https://check.torproject.org/${WHITE} (ctrl + click)"
  echo -e "${BGREEN}OLD ip adress: ${BBLUE}"
  echo $Old_IP
  echo ""
  echo -e "${BWHITE}Press [Enter] when you want to ${BRED}stop${BWHITE} the script and revert changes"
  read -p "$*"
}

#A fonction to revert changes
function STOP ()
{

  clear
  echo ""
  echo -e "${BWHITE}Changing iptables rules to ${BBLUE}stop rerouting all trafic throug tor${WHITE}"
  cd toriptables2
  (sudo python toriptables2.py -f
  )> /dev/null 2>&1
  cd ..
  echo ""
  echo -e "${BWHITE}Disabling network services"
  sudo systemctl stop NetworkManager
  echo ""
  echo -e "${BBLUE}Reverting mac adress to the permanent one${BWHITE}"
  (sudo macchanger -p $(echo $Interface)
  )> /dev/null 2>&1
  echo ""
  echo "Rebooting network services"
  sudo systemctl start NetworkManager
  echo ""
  echo -e "Waiting to the network to reboot properly...${WHITE}(can take some time)"
  sleep 11s
}



clear
echo -e "${BRED} _____                           _            "
echo          "|  _  |___ ___ ___ _ _ _____ ___| |_ ___ ___  "
echo          "|     |   | . |   | | |     | .'|  _| . |  _| "
echo          "|__|__|_|_|___|_|_|_  |_|_|_|__,|_| |___|_|   "
echo -e       "                  |___|                       "
echo -e "       ${BBLUE}Made with <3 From France by Timothe P${BWHITE}"
echo -e "1: Spoof your mac adress"
echo "2: Reroute all your conexions throug tor"
echo -e "3: Do both (${BGREEN}Recomanded${BWHITE})"
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
          STOP


elif [ $C = "2" ]
then
          tor_iptables2
          internet_test
          internet_loop
          informations
          STOP


elif [ $C = "3" ]
then
          spoof_mac
          tor_iptables2
          internet_test
          internet_loop
          informations
          STOP


elif [ $C = "4" ]
then
          clear
          echo -e "${BWHITE}Downloading and installing tor"
          (sudo apt-get install tor -y
          )> /dev/null 2>&1
          echo ""
          echo -e "Downloading and installing macchanger${WHITE}"
          sudo apt-get install macchanger -y
          echo -e "${BWHITE}"
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
          (sudo rm -rf torghost
          )> /dev/null 2>&1
          echo "Installing net-tools"
          echo ""
          (sudo apt install net-tools
          )> /dev/null 2>&1
          echo "Installing NetworkManager"
          echo ""
          (sudo apt-get install network-manager
          )> /dev/null 2>&1
          echo "Downloading Toriptables 2"
          echo ""
          (git clone https://github.com/ruped24/toriptables2
          )> /dev/null 2>&1
          echo -e "${BGREEN}All dependencies installed!"
          echo ""
          echo "Restart the script to use it! "
else
echo -e "${BRED}Wrong entry${BWHITE}"
fi
