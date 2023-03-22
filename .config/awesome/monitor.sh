#!/bin/sh

monitor="$(xrandr | grep -e "\Wconnected" | grep -v eDP | awk '{print $1}')"
if [ $monitor ]; then
    # connect to the found monitor
    xrandr --output $monitor --right-of eDP --auto
else
    # disconnect ot every known monitors
    for m in $(xrandr | grep disconnected | awk '{print $1}'); do
        xrandr --output $m --off
    done
fi
