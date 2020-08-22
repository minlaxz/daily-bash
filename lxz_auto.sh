#!/bin/sh
# bash by minlaxz `https://github.com/minlaxz`

lxz_path=$HOME/.local/share/lxz.gosh
lxz_tmp=$HOME/.local/share/lxz.tmp

exit_tasks() {
    echo '("Exiting")'
    if [[ -d $lxz_tmp ]]; then
       rm -rvf $lxz_tmp && echo "lxz' tmp cleaned."
    else echo "no tmp to clean."
    fi
}

_lxz_installer(){
    helper lxz_installer
    git clone https://github.com/minlaxz/daily-bash.git $lxz_path

    #configure
    if [[ $SHELL == /usr/bin/zsh ]]; then
        if grep -Fxq 'alias lxz="$HOME/.local/share/lxz.gosh/lxz.sh"' ~/.zshrc
        then
	        echo "lxz - found"
        else
	        echo "lxz - not found"
            echo "alias lxz='$HOME/.local/share/lxz.gosh/lxz.sh'" >> ~/.zshrc 
            source ~/.zshrc
        fi
    else
        if grep -Fxq 'alias lxz="$HOME/.local/share/lxz.gosh/lxz.sh"' ~/.bashrc
        then
	        echo "lxz - found"
        else
	        echo "lxz - not found"
            echo "alias lxz='$HOME/.local/share/lxz.gosh/lxz.sh'" >> ~/.bashrc 
            source ~/.bashrc
        fi
    fi
    exit_tasks
}

_lxz_uninstaller() {
    helper lxz_uninstaller
    if [[ -d $lxz_path ]]; then
        read -p "Do you want to uninstall ? y/[n] :" u
        if [[ $u == y ]];then
            rm -rvf $lxz_path
            echo "lxz - removed."
        else echo "Cancled."
        fi
    else 
        echo "lxz is not installed already."
    fi
    
}

_lxz_() {
    helper lxz_help
    read -p " what do you say x3 : " u
    case "$u" in
        1 | --[i]* ) _lxz_installer ;;
        2 | --[u]* ) _lxz_uninstaller ;;
        x | --[x]* ) exit_tasks ;;
        *)  echo " ./Not an option <$u>.Choose: 1/2.. "
            echo " > ::visit https://daemon-laxz.web.app for details."
            echo ""
            _lxz_ ;;
        esac
}

helper(){
    case $1 in 
    lxz_help)
        echo ""
        echo -e "\e[1;31m--lxz installer--\e[0m"
        echo "1)install."
        echo "2)uninstall."
        echo "x)exit."
        ;;
    lxz_installer)
        echo " > lxz - installing."
        ;;
    lxz_uninstaller)
        echo " > lxz - removing."
        ;;
    *)
        echo "Enternal Arror \OwO/"
        ;;
    esac
}
_lxz_