#!/bin/sh
lxz_tmp=$HOME/.local/share/lxz.tmp && \
mkdir -p $lxz_tmp && \
curl https://raw.githubusercontent.com/minlaxz/lxz/master/lxz_auto.sh --output $lxz_tmp/lxz_init.sh && \
chmod 744 $lxz_tmp/lxz_init.sh && \
bash $lxz_tmp/lxz_init.sh