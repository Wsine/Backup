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
    wget -q $GITHUB_DIR/$filename -O $OUTPUT_DIR/$filename
    info $filename
}

function download_bash() {
    check_env "wget"

    download ".bashrc"
    download ".inputrc"
    download ".bash_aliases"
}

function download_zsh() {
    check_env "wget"
    check_env "git"
    check_env "zsh"

    # install oh-my-zsh
    if [ ! -d "$OUTPUT_DIR/.oh-my-zsh/" ]; then
        git clone -q --depth=1 https://github.com/robbyrussell/oh-my-zsh.git \
            $OUTPUT_DIR/.oh-my-zsh
    fi

    download ".zshrc"

    # show hints
    echo -e "use \033[01;34mchsh -s \$(which zsh)\033[00m to change default shell"
    echo "then logout and login to enable zsh environment"
}

function download_theme() {
    check_env "wget"

    # install dark theme
    if [ ! -n "$SSH_CONNECTION" ]; then
        wget -q -O xt http://git.io/v3D8R && chmod +x xt && ./xt &> /dev/null && rm xt
    fi
}

function download_vim() {
    check_env "wget"
    check_env "vim"

    # install vundle
    if [ ! -d "$OUTPUT_DIR/.vim/bundle/Vundle.vim/" ]; then
        git clone -q --depth=1 https://github.com/VundleVim/Vundle.vim.git  \
            $OUTPUT_DIR/.vim/bundle/Vundle.vim
    fi

    # install fonts with powerline
    if [ ! -n "$SSH_CONNECTION" ]; then
        check_env "fc-cache"
        check_path "$OUTPUT_DIR/.fonts"
        download ".fonts/PowerlineSymbols.otf"
        fc-cache $OUTPUT_DIR/.fonts
        check_path "$OUTPUT_DIR/.config/fontconfig/conf.d"
        download ".config/fontconfig/conf.d/10-powerline-symbols.conf"
    fi

    check_path "$OUTPUT_DIR/.vim/colors"
    download ".vim/colors/desert.vim"
    download ".vimrc"

    # install vim plugins
    vim +PluginInstall +qall
}

function download_tmux() {
    check_env "wget"
    check_env "tmux"

    download ".tmux.conf"
}

function download_all() {
    download_bash
    download_tmux
    download_theme
    download_zsh
    download_vim
}

# check input and run
if [ ! -z "$2" ] && [ "$2" == "debug" ]; then
    check_path "$(pwd)/test"
    OUTPUT_DIR=$(pwd)/test
fi

case $1 in
    bash)
        download_bash
        ;;
    zsh)
        download_zsh
        ;;
    tmux)
        download_tmux
        ;;
    vim)
        download_vim
        ;;
    theme)
        download_theme
        ;;
    all)
        download_all
        ;;
    *)
        echo "bash | zsh | tmux | vim | theme | all, at least one option is required."
        ;;
esac

