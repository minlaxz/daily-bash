#!/bin/sh
tmp_prefix=$HOME/.local/share/lxz.tmp && \
mkdir -p $tmp_prefix && \
curl https://raw.githubusercontent.com/minlaxz/daily-bash/master/laxz_autoconfig.sh --output $tmp_prefix/lxz_init.sh && \
chmod 744 $tmp_prefix/lxz_init.sh && \
bash $tmp_prefix/lxz_init.sh