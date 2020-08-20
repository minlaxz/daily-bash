#!/bin/sh
lxz_prefix=$HOME/.local/share/lxz.gosh/tmp && \
mkdir -p $lxz_prefix && \
curl https://raw.githubusercontent.com/minlaxz/daily-bash/master/laxz_autoconfig.sh --output $lxz_prefix/lxz_init.sh && \
chmod 744 $lxz_prefix/lxz_init.sh && \
bash $lxz_prefix/lxz_init.sh