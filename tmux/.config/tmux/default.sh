#!/bin/sh

session="default"
if tmux ls | grep $session > /dev/null
then
    tmux -u a -t $session
else
    tmux -f ~/.config/tmux/tmux.conf new-session -d -s $session
    tmux rename-window 'Odoo'
    tmux select-window -t $session:1
    tmux send-keys 'cd src/odoo' 'C-m'
    tmux split-window
    tmux send-keys 'cd src/enterprise' 'C-m'
    tmux new-window -t $session -n 'Nvim'
    tmux send-keys 'cd src/enterprise' 'C-m'
    tmux new-window -t $session -n 'Upgrade'
    tmux send-keys 'cd src/upgrade' 'C-m'
    tmux new-window -t $session -n 'Task'
    tmux send-keys 'taskwarrior-tui' 'C-m'
    tmux select-window -t $session:2
    tmux send-keys 'nvim' 'C-m'
    tmux -u attach-session -t $session
fi
