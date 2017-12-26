#!/bin/bash

# set input from and output to
GITHUB_DIR="https://raw.githubusercontent.com/Wsine/Backup/master/linux"
OUTPUT_DIR="$HOME"
HINTS="all done."
if [ "$1" = "all" ]; then
    DOWNLOAD_ALL=true
fi

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

function check_sudo() {
    sudo -n true &> /dev/null
    if [ "$?" -eq 0 ] || [ "$?" -eq 1 ]; then
        echo "sudo access granted"
    else
        echo "sudo access denied"
        exit 1
    fi
}

function check_for_install() {
    local execname=$1
    command -v $execname &> /dev/null || {
        sudo apt-get install -y $execname
        info $execname
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

    # install environment
    if [ "$DOWNLOAD_ALL" = true ]; then
        check_sudo
        check_env "apt-get"
        check_env "git"
        check_env "curl"
        check_env "chsh"
        check_env "fc-cache"

        check_for_install "vim"
        # install vundle
        if [ ! -d "$OUTPUT_DIR/.vim/bundle/Vundle.vim/" ]; then
            check_path "$OUTPUT_DIR/.vim/bundle"
            git clone -q --depth=1 https://github.com/VundleVim/Vundle.vim.git  \
                $OUTPUT_DIR/.vim/bundle/Vundle.vim
        fi
        # install fonts with powerline
        if [ ! -d "$OUTPUT_DIR/.fonts" ]; then
            check_path "$OUTPUT_DIR/.fonts"
            check_for_download "vim" "PowerlineSymbols.otf" ".fonts"
            fc-cache $OUTPUT_DIR/.fonts
            check_path "$OUTPUT_DIR/.config/fontconfig/conf.d"
            check_for_download "vim" "10-powerline-symbols.conf" \
                                ".config/fontconfig/conf.d"
        fi

        check_for_install "zsh" \
            && echo "change default shell to zsh, password required" \
            && chsh -s $(which zsh) \
            && HINTS+="\n logout and login to enable zsh environment"
        # install oh-my-zsh
        if [ ! -d "$OUTPUT_DIR/.oh-my-zsh/" ]; then
            git clone -q --depth=1 https://github.com/robbyrussell/oh-my-zsh.git \
                $OUTPUT_DIR/.oh-my-zsh
        fi

        # install dark theme
        wget -q -O xt http://git.io/v3D8R && chmod +x xt && ./xt &> /dev/null && rm xt
    fi

    # download file if needed
    check_for_download "bash" ".inputrc"
    check_for_download "bash" ".bashrc"
    check_for_download "bash" ".bash_aliases"
    check_for_download "tmux" ".tmux.conf"
    check_for_download "vim" ".vimrc"
    check_for_download "vim" "desert.vim" ".vim/colors"
    check_for_download "zsh" ".zshrc" "" "s/user_name/"$USER"/g"

    # install vim plugin
    if [ "$DOWNLOAD_ALL" = true ]; then
        vim +PluginInstall +qall
    fi
}

main && echo -e "$HINTS"
