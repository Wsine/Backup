#!/bin/bash

# set input from and output to
GITHUB_DIR="https://raw.githubusercontent.com/Wsine/Backup/master/linux"
OUTPUT_DIR="$HOME"

function info() {
    local filename=$1
    if [ $? -eq 0 ]; then
        echo "download success ==> $filename"
    fi
}

function error() {
    local execname=$1
    echo "-- ERROR: no $execname executable is found."
    exit 1
}

function check_env() {
    local execname=$1
    command -v $execname &> /dev/null || {
        error $execname
    }
}

function check_path() {
    local path=$1
    if [ ! -d "$path" ]; then
        mkdir -p $path
    fi
}

function download() {
    local filename=$1
    local specpath=$2
    wget -q $GITHUB_DIR/$filename -O $OUTPUT_DIR/$specpath/$filename
    info $filename
}

function check_for_download() {
    local cmd=$1
    local filename=$2
    local specpath=$3
    local replace=$4
    if command -v $cmd > /dev/null; then
        if [ -n "$specpath" ]; then
            check_path "$OUTPUT_DIR/$specpath"
        fi
        download $filename $specpath
        if [ -n "$replace" ]; then
            sed -i "$replace" $OUTPUT_DIR/$specpath/$filename
        fi
    fi
}

function main() {
    # check compile environment
    check_env "wget"
    check_env "sed"

    # check path
    check_path "$OUTPUT_DIR"

    # download file if needed
    check_for_download "bash" ".inputrc"
    check_for_download "bash" ".bashrc"
    check_for_download "bash" ".bash_aliases"
    check_for_download "tmux" ".tmux.conf"
    check_for_download "vim" ".vimrc"
    check_for_download "vim" "desert.vim" ".vim/colors"
    check_for_download "zsh" ".zshrc" "" "s/user_name/"$USER"/g"
}

main && echo "all downloads success."

