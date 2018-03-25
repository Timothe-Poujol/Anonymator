#!/bin/bash
# Anonymise yourself
sudo echo ""
echo " _____                           _            "
echo "|  _  |___ ___ ___ _ _ _____ ___| |_ ___ ___  "
echo "|     |   | . |   | | |     | .'|  _| . |  _| "
echo "|__|__|_|_|___|_|_|_  |_|_|_|__,|_| |___|_|   "
echo "                  |___|                       "
echo "Made with <3 From France"
echo "1: Change your mac adress"
echo "2: Reroute all your conexions throug tor"
echo "3: Do both"
echo "4: Install dependencies (you need to do it once)"

#Declaring variables
read -p "Your Choice: " C
Interface=$(ip route list | grep default | awk '{print $5} ')

#Menu in the console
if [ $C = "1" ]
      then
          echo "Disabling network services"
          (sudo service NetworkManager stop
          sudo ifconfig $( echo $Interface) down
          )> /dev/null 2>&1
          echo "Changing mac adress"
          (sudo macchanger -r $(echo $Interface)
          )> /dev/null 2>&1
          echo "Rebooting network services"
          (sudo ifconfig $(echo $Interface) up
          sudo service NetworkManager start
          )> /dev/null 2>&1
          echo "Your mac adress has been changed:"
          sudo macchanger -r $( echo $Interface)
      elif [ $C = "2" ]
        then
          echo "Disabling network services"
          (sudo ifconfig $( echo $Interface) down
          )> /dev/null 2>&1
          echo "Starting torghost"
          (sudo torghost start
          )> /dev/null 2>&1
          echo "Rebooting network services"
          (sudo ifconfig $(echo $Interface) up
          )> /dev/null 2>&1
          echo "Your IP adress is now hidden"
      elif [ $C = "3" ]
        then
            sudo torghost start

      elif [ $C = "4" ]
        then
          clear
          (sudo apt-get install tor
          )> /dev/null 2>&1
          echo "Installing macchanger"
          (sudo apt-get install macchanger
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
          echo "All dependencies installed!"
        else
          echo "Wrong entry"
fi
