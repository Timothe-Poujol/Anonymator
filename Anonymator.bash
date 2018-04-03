#!/bin/bash
# Anonymise yourself
sudo echo ""

RED='\033[91m'
END='\033[0m'
GREEN='\033[1;32m'
BLUE='\033[94m'
BOLD='\033[1m'


#A fonction to test if the internet conexion is still working
internet_test ()
{
  echo ""
  echo ""
  echo ""
  echo "Do you want to test if your internet connexion still work?"
  echo -e "${GREEN} 1: Yes (recommended)${END}"
  echo " 2: No"
  read -p "Your Choice: " N
  clear
  if [ $N = "1" ]
  then
  Network=$(ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo ok || echo error)
  clear
                if [ $Network = "ok" ]
                  then
                      echo -e "${GREEN}Internet is working! Nice!${END}"
                elif [ $Network = "error" ]
                  then
                      echo ""
                      echo ""
                      echo ""
                      echo -e "${RED}${BOLD}Internet is not working...${END}${BOLD} Sorry, i try to avoid this bugs in my script, but it's hard...${END}"
                      echo ""
                      echo -e "${BOLD}I'm sorry, you need to reboot to get internet back...${END}"
                      echo -e "${GREEN}Reboot now? (Y/N)${END}"
                      read -p "Your Choice: " R
                      #Internet does not work. Asking the user if he wants to reboot to fix the problem.
                            if [ $R = "Y" ]
                            then
                              reboot
                            else
                              echo "Okay, don't forget to reboot later!"
                            fi
  #end of the if, comming back to the test internet menu
                 else
                            echo -e "${RED}Wrong entry${END}"
                 fi
  elif [ $N = "2" ]
  then
    echo "Okay! If you have network issues don't forget to reboot!"
  else
    echo -e "${RED}Wrong entry${END}"
  fi
}



clear
echo -e "${RED} _____                           _            "
echo          "|  _  |___ ___ ___ _ _ _____ ___| |_ ___ ___  "
echo          "|     |   | . |   | | |     | .'|  _| . |  _| "
echo          "|__|__|_|_|___|_|_|_  |_|_|_|__,|_| |___|_|   "
echo -e       "                  |___|                       ${END}"
echo -e "${GREEN}Made with <3 From France${END}"
echo -e "${BOLD}1: Change your mac adress"
echo "2: Reroute all your conexions throug tor"
echo "3: Do both"
echo -e "4: Install dependencies (you need to do it once)${END}"


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
          echo ""
          echo ""
          echo -e "${BOLD}waiting to the network to reboot properly...${END}(10s)"
          sleep 10s
          internet_test



elif [ $C = "2" ]
then
          echo "Starting torghost"
          echo ""
          echo "torghost output:"
          sudo torghost start
          echo ""
          echo "Your IP adress is now hidden"
          internet_test



elif [ $C = "3" ]
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
            echo ""
            echo ""
            echo -e "${BOLD}waiting to the network to reboot properly...${END}(10s)"
            sleep 10s
            sudo torghost start
            internet_test



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
          echo -e "${GREEN}All dependencies installed!"
          echo ""
else
          echo -e "${RED}Wrong entry${END}"
fi
sleep 4
clear
echo ""
echo -e "${BOLD}You are anonymous now!"
echo -e "Thanks for using this script! :) Goodbye!${END}"
echo ""
echo ""
echo ""
echo -e "${BOLD}If you want to cut torghost, type: ${END}${RED}sudo torghost stop${END}"
echo "(You can also reboot)"
