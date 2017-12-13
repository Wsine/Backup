#!/bin/bash

# set input from and output to
GITHUB_DIR="https://raw.githubusercontent.com/Wsine/Backup/master/linux"
OUTPUT_DIR="~"

# check compile environment
command -v wget || {
    echo "-- ERROR: no wget executable is found."
    exit 1
}

command -v sed || {
    echo "-- ERROR: no sed executable is found."
    exit 1
}

# check path
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# install ~/.inputrc
wget $GITHUB_DIR/.inputrc -O $OUTPUT_DIR/.inputrc

# install ~/.bashrc
if command -v bash > /dev/null; then
    wget $GITHUB_DIR/.bashrc -O $OUTPUT_DIR/.bashrc
fi

# install ~/.bash_aliases
if command -v bash > /dev/null; then
    wget $GITHUB_DIR/.bash_aliases -O $OUTPUT_DIR/.bash_aliases
fi

# install ~/.zshrc
if command -v zsh > /dev/null; then
    wget $GITHUB_DIR/.zshrc.example -O $OUTPUT_DIR/.zshrc
    sed -i 's/user_name/'$USER'/g' $OUTPUT_DIR/.zshrc
fi

# install ~/.tmux.conf
if command -v tmux > /dev/null; then
    wget $GITHUB_DIR/.tmux.conf -O $OUTPUT_DIR/.tmux.conf
fi

# install ~/.vimrc
if command -v vim > /dev/null; then
    wget $GITHUB_DIR/.vimrc -O $OUTPUT_DIR/.vimrc
    if [ ! -d "$OUTPUT_DIR/.vim/colors" ]; then
        mkdir -p $OUTPUT_DIR/.vim/colors
    fi
    wget $GITHUB_DIR/desert.vim -O $OUTPUT_DIR/.vim/colors/desert.vim
fi

