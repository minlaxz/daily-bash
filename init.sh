#!/usr/bin/env sh
# Purpose : Auto configure linux system
#           & intented for machine learning.
# Author : minlaxz

lxz_init_tmp=$HOME/.local/share/lxz.tmp && mkdir -p $lxz_init_tmp && \
curl https://raw.githubusercontent.com/minlaxz/lxz/master/lxz_auto_config.sh --output $lxz_init_tmp/lxz_init.sh && \
chmod 755 $lxz_init_tmp/lxz_init.sh && \
/usr/bin/env sh $lxz_init_tmp/lxz_init.sh