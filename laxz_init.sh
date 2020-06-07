#!/bin/sh
sudo apt install curl
curl https://raw.githubusercontent.com/minlaxz/daily-bash/master/laxz_autoconfig.sh --output /home/$USER/laxz_init.sh
chmod 744 /home/$USER/laxz_init.sh
./home/$USER/laxz_init.sh
