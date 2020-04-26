#!/bin/bash

help_func(){
    echo "-h , --help , print this help message and exit."
    echo "-b, --brightness, change screen brightness (0.5 to 1.4)."
    echo "-i , --internet , check internet."
    echo "-u, --update , pkg update and upgrade."
}

internet(){
    echo "Checking Internet ..."
}

brightness(){
    if [[ $1 == "" || $1 < 0.5 || $1 > 1.4 ]]; then
        echo "brightness $1 {value error}."
    else
        echo "brightness set"
    fi
}

update(){
    sudo apt update
    read -p 'do you want to upgrade: y/n ' uservar
    if [ $uservar == 'y' ]; then
        echo "upgrade" #TODO
    else
        echo "user aborded."
    fi
}

encryptor(){
    echo "---enCRYption---"
    echo "$1"
}

zipper(){
    timenow=$(date +"%Y-%m-%d-%T")
    echo "---zip---"
    zip -r /home/$USER/laxz-$timenow.zip $*
    read -p 'do you want to encrypt: y/n ' uservar
    if [ $uservar == 'y' ]; then
        encryptor /home/$USER/laxz-$timenow.zip
    fi
}

if [ $# == 0 ]; then
    echo "Option(s) needed."
    help_func
else
    case "$1" in

	-h) help_func ;; 
	-b) brightness $2 ;; 
    -z) zipper $* ;;
	-i) internet ;; 
    -u) update ;;
	*) echo "Option $1 not recognized" ;;

	esac
fi