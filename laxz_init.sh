#!/bin/sh
prefix=/home/$USER/.local/share/.laxz && \
mkdir -p $prefix && \
curl https://raw.githubusercontent.com/minlaxz/daily-bash/master/laxz_autoconfig.sh --output $prefix/laxz_init.sh && \
chmod 744 $prefix/laxz_init.sh && \
bash $prefix/laxz_init.sh