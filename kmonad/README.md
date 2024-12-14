# Ref: https://www.swe-devops.com/posts/kmonad-service-systemd/

# Emplace file
Add the ./my_kmonad.service file to:
    `/etc/systemd/system/` 

# Reload systemd
sudo systemctl daemon-reload

# Start the my_kmonad service
sudo systemctl start my_kmonad

# Enable the my_kmonad service to start on boot
sudo systemctl enable my_kmonad

# Check the status of your service
sudo systemctl status my_kmonad
