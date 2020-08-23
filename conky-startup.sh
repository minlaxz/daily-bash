#!/bin/sh

sleep 5
#conky -q -c $HOME/.conky/conkyLrc &
conky -q -c $HOME/.conky/conkyRrc &
conky -q -c $HOME/.conky/conkyDockrc &
exit 0