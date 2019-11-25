#!/bin/sh

# install vimrc
ln -s $(cd $(dirname $0) && pwd)/vimrc ~/.vimrc

# install rofi config
mkdir -p ~/.config/rofi/
ln -s $(cd $(dirname $0) && pwd)/rofi-config ~/.config/rofi/config

# install bashrc
ln -s $(cd $(dirname $0) && pwd)/bashrc ~/.bashrc

