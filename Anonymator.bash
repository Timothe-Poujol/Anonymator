#!/bin/bash
# Anonymise yourself
echo " _______                                    __                    "
echo "|   _   |.-----.-----.-----.--.--.--------.|__|.-----.-----.----. "
echo "|       ||     |  _  |     |  |  |        ||  ||__ --|  -__|   _| "
echo "|___|___||__|__|_____|__|__|___  |__|__|__||__||_____|_____|__|   "
echo "                           |_____|                                "
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
          cd torghost
          chmod +x install.sh
          sudo ./install.sh
          echo "All dependencies installed!"
        else
          echo "Wrong entry"
fi
