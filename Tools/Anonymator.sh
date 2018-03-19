#!/bin/sh

# Ititialization

mainmenu () {
  echo "Press 1 to change your mac adress"
  echo "Press 2 to reroute all your connexions through tor using TORGHOST"
  echo "Press 3 To do both"
  echo "Press 4 to install the dependencies (Needed to run the script)"
  echo "Press x to exit the script"
  read -n 1 -p "Input Selection:" mainmenuinput
  if [ "$mainmenuinput" = "1" ]; then
            sudo macchanger -r $(ip route list | grep default | awk '{print $5} ')
            sudo service network-manager restart
            clear
            echo "Your mac adress has been changed:"
            sudo macchanger -r $(ip route list | grep default | awk '{print $5} ')
        elif [ "$mainmenuinput" = "2" ]; then
            torghost start
        elif [ "$mainmenuinput" = "3" ]; then
          sudo macchanger -r $(ip route list | grep default | awk '{print $5} ')
          sudo service network-manager restart
          sudo torghost start
          echo "Your mac adress has been changed:"
          sudo macchanger -r $(ip route list | grep default | awk '{print $5} ')
        elif [ "$mainmenuinput" = "4" ]; then
          sudo apt-get install tor
          sudo apt-get install macchanger
          cd torghost
          chmod +x install.sh
          sudo ./install.sh
          echo "if you see some errors, please google them and inform me about them :)"
        elif [ "$mainmenuinput" = "x" ];then
            quitprogram
        elif [ "$mainmenuinput" = "X" ];then
            quitprogram
        else
            echo "You have entered an invallid selection!"
            echo "Please try again!"
            echo ""
            echo "Press any key to continue..."
            read -n 1
            clear
            mainmenu
        fi
}

# This builds the main menu and routs the user to the function selected.

mainmenu

# This executes the main menu function.
# Let the fun begin!!!! WOOT WOOT!!!!
