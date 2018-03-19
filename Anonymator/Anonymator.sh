sudo macchanger -r $(ip route list | grep default | awk '{print $5} ')
sudo service network-manager restart
echo "Mac adress changed"
sudo torghost start
