#!/bin/sh
laxz_prefix=$HOME/.local/share/laxz/tmp && \
mkdir -p $laxz_prefix && \
curl https://raw.githubusercontent.com/minlaxz/daily-bash/master/laxz_autoconfig.sh --output $laxz_prefix/laxz_init.sh && \
chmod 744 $laxz_prefix/laxz_init.sh && \
bash $laxz_prefix/laxz_init.sh