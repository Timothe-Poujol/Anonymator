#!/bin/bash
# Anonymise yourself
echo " _____                           _            " 
echo "|  _  |___ ___ ___ _ _ _____ ___| |_ ___ ___  "
echo "|     |   | . |   | | |     | .'|  _| . |  _| "
echo "|__|__|_|_|___|_|_|_  |_|_|_|__,|_| |___|_|   "
echo "                  |___|                       "
echo "1: Change your mac adress"
echo "2: Reroute all your conexions throug tor"
echo "3: Do both"
echo "4: Install dependencies (you need to do it once)"
read -p "Your Choice: " C
if [ $C = "1" ]
      then
          sudo macchanger -r $(ip route list | grep default | awk '{print $5} ')
          sudo service network-manager restart
          clear
          echo "Your mac adress has been changed:"
          sudo macchanger -r $(ip route list | grep default | awk '{print $5} ')
      elif [ $C = "2" ]
        then
          sudo torghost start

      elif [ $C = "3" ]
        then
            .//Tools/Macchanger.sh
            torghost start

      elif [ $C = "4" ]
        then
          sudo apt-get install tor
          sudo apt-get install macchanger
          git clone https://github.com/susmithHCK/torghost.git
          cd torghost
          chmod +x install.sh
          sudo ./install.sh
          cd ..
          sudo rm -rf torghost
          echo "All dependencies installed!"
        else
          echo "Wrong entry"
fi
