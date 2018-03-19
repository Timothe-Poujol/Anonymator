sudo ifconfig $(ip route list | grep default | awk '{print $5} ') down
sudo macchanger -r $(ip route list | grep default | awk '{print $5} ')
sudo ifconfig $(ip route list | grep default | awk '{print $5} ') up
sudo torghost start
