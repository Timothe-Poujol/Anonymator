#!/bin/bash
# Anonymise yourself
sudo echo ""
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[92m'
BLUE='\033[0;34m'
echo -e "${RED} _____                           _            "
echo          "|  _  |___ ___ ___ _ _ _____ ___| |_ ___ ___  "
echo          "|     |   | . |   | | |     | .'|  _| . |  _| "
echo          "|__|__|_|_|___|_|_|_  |_|_|_|__,|_| |___|_|   "
echo -e       "                  |___|                       ${NC}"
echo -e "${GREEN}Made with <3 From France${NC}"
echo "1: Change your mac adress"
echo "2: Reroute all your conexions throug tor"
echo "3: Do both"
echo "4: Install dependencies (you need to do it once)"

#Declaring variables
read -p "Your Choice: " C
Interface=$(ip route list | grep default | awk '{print $5} ')
clear
#Menu in the console
if [ $C = "1" ]
then
          echo ""
          echo "Disabling network services"
          (sudo service NetworkManager stop
          sudo ifconfig $( echo $Interface) down
          )> /dev/null 2>&1
          echo ""
          echo "Changing mac adress"
          (sudo macchanger -r $(echo $Interface)
          )> /dev/null 2>&1
          echo ""
          echo "Rebooting network services"
          (sudo ifconfig $(echo $Interface) up
          sudo service NetworkManager start
          )> /dev/null 2>&1
          echo ""
          echo "Your mac adress has been changed:"
          sudo macchanger -r $( echo $Interface)
elif [ $C = "2" ]
then
          echo "Starting torghost"
          echo ""
          echo "torghost output:"
          sudo torghost start
          echo ""
          echo "Your IP adress is now hidden"
elif [ $C = "3" ]
then
            sudo torghost start

elif [ $C = "4" ]
then
          clear
          echo "Downloading and installing tor"
          (sudo apt-get install tor -y
          )> /dev/null 2>&1
          echo ""
          echo "Downloading and installing macchanger"
          (sudo apt-get install macchanger -y
          )> /dev/null 2>&1
          echo ""
          echo "Downloading and installing python pip"
          echo "(28MB + dependencies) -> Can take some time"
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
          echo -e "${GREEN}All dependencies installed!${NC}"
else
          echo -e "${RED}Wrong entry${NC}"
fi
sleep 4
clear
#testing if internet still work
echo "Do  you want to test if your internet connexion still work?"
echo -e "${BLUE}1: Yes (recommended)${NC}"
echo "2: No"
read -p "Your Choice: " N
clear
if [ $N = "1" ]
  then
Network=$(ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo ok || echo error)
              if [ $Network = "ok" ]
                then
                    echo -e "${GREEN}Internet is working! Nice!${NC}"
              elif [ $Network = "error" ]
                then
                    echo "${RED}Internet is not working...${NC} Sorry, i try to avoid this bugs in my script, but it's hard..."
                    echo ""
                    echo "I'm sorry, you need to reboot to get internet back..."
                    echo "Reboot now? (Y/N)"
                    read -p "Your Choice: " R
#does the user wants to reboot? Test with another if
                          if [ $R = "Y" ]
                          then
                            reboot
                          else
                            echo "Okay, don't forget to reboot later!"
                          fi
#end of the if, comming back to the test internet menu
               else
                          echo -e "${RED}Wrong entry${NC}"
               fi
elif [ $N = "2" ]
then
  echo "Okay! If you have network issues don't forget to reboot!"
else
  echo -e "${RED}Wrong entry${NC}"
fi
echo ""
echo ""
echo "Thanks for using this script! :) Goodbye!"
echo ""
echo ""
echo ""
echo -e "If you want to cut torghost, type: ${RED}sudo torghost stop${NC}"
