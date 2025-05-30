#!/bin/sh

B='00000000'  # blank
C='#ffffff22'  # clear ish
D='#8C6751'  # default
T='#9CA686'  # text
W='#E0CBB1'  # wrong
V='#D9AB82'  # verifying

file=$(find $HOME/Pictures/lockscreen -type f | shuf -n 1)

$HOME/.local/bin/i3lock \
--insidever-color=$C   \
--ringver-color=$V     \
\
--scale               \
--radius 150         \
--insidewrong-color=$C \
--ringwrong-color=$W   \
\
--inside-color=$B      \
--ring-color=$D        \
--line-color=$B        \
--separator-color=$D   \
\
--verif-color=$T        \
--wrong-color=$T        \
--time-color=$T        \
--date-color=$T        \
--layout-color=$T      \
--keyhl-color=$W       \
--bshl-color=$W        \
\
--image $file          \
--clock               \
--time-str="%H:%M:%S"  \
--date-str="%A, %m %Y" \
