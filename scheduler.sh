#!/bin/bash

export HOME=/home/ubuntu
export PLENV_ROOT=$HOME/.plenv
export PATH=$PLENV_ROOT/bin:$PATH
eval "$(plenv init -)"
cd $HOME/Scheduler
exec plenv exec carton exec plackup -Ilib -R ./lib -E production --access-log /dev/null -p 5000 -a ./script/scheduler-server

