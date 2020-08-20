#!/bin/sh
# by minlaxz `https://github.com/minlaxz`

set -e

lxz_path=$HOME/.local/share/lxz.gosh
lxz_tmp=$HOME/.local/share/lxz.tmp

exit_tasks() {
    echo ' > ::("Exiting")'
    if [[ -d $lxz_tmp ]]; then
       rm -rvf $lxz_tmp && echo "lxz' tmp cleaned."
    else echo "no tmp to clean."
    fi
    exit
}

not_option(){
    echo " > ::Not an option."
}

_lxz_installer(){
    helper lxz_installer
    git clone https://github.com/minlaxz/daily-bash.git $lxz_path
    if [[ $SHELL == /usr/bin/zsh ]]; then
    echo "alias lxz=$HOME/.local/share/lxz.gosh/lxz.sh" >> ~/.zshrc 
    source ~/.zshrc
    else
    echo "alias lxz=$HOME/.local/share/lxz.gosh/lxz.sh" >> ~/.bashrc 
    source ~/.bashrc
    fi
    _lxz_checker
    
}

_lxz_uninstaller() {
    helper lxz_uninstaller
    if [[ -d $lxz_path ]]; then
        read -p "Do you want to uninstall ? y/[n] :" u
        if [[ $u == y ]];then
            rm -rvf $lxz_path
            echo "lxz cleaned."
        else echo "Cancled."
        fi
    else 
        echo "lxz is not installed."
    fi
    
}

_lxz_checker(){
    if [[ -f $lxz_path/lxz.sh ]]; then
        git -C $lxz_path pull https://github.com/minlaxz/daily-bash.git
        helper lxz_checker
    else 
        printf "\nlxz is not installed\n"
        read -p "Do you want to install ? y/[n] : " u
        if [[ $u == y ]]; then
            _lxz_installer
        else 
            _lxz_
        fi
    fi
}

_lxz_() {
    helper lxz_help
    read -p " what do you say x3 : " u
    case "$u" in
        1 | --[i]* ) _lxz_installer ;;
        2 | --[u]* ) _lxz_uninstaller ;;
        3 | --[c]* ) _lxz_checker ;;
        x | --[x]* ) exit_tasks ;;
        *)  not_option
            echo " > ::<$u>.Choose: 1/2.. "
            echo " > ::visit https://minlaxz.me for detail."
            echo ""
            _lxz_ ;;
        esac
}

helper(){
    case $1 in 
    lxz_help)
        echo ""
        echo -e "\e[1;31m--lxz installer--\e[0m"
        echo ""
        echo "1)in..."
        echo "2)un..."
        echo "3)cxk..."
        echo "x)exit."
        ;;
    lxz_installer)
        echo " > lxz - installing."
        ;;
    lxz_uninstaller)
        echo " > lxz uninstall is still building."
        ;;
    lxz_checker)
        echo " > lxz updated."
        ;;
    *)
        echo "Enternal Arror OwO"
        ;;
    esac
}
_lxz_