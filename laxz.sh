#!/bin/bash
version='1.0.0'
developer='minlaxz'
usage(){
    echo "-h , --help , print this help message and exit."
    echo "-b, --brightness, change screen brightness (0.5 to 1.4)."
    echo "-i , --internet , check internet."
    echo "-u, --update , pkg update and upgrade."
    echo "-z, --zip, zip any given {file(s)} {folder(s)}"
    echo "-e, --encrypt, encrypt given {file} with aes256"
    echo "-d, --decrypt, decrypt laxz encrpyted {enc_file} aes256"
}

internet(){
    echo -e "Checking internet connection ..."
    wget -q --spider http://example.com
    if [ $? -eq 0 ] ; then
            echo "Internet connection is Noice."
    else
            echo -e "[INFO]: Cannot make online stuff!\nExiting ..."
            exit 0
    fi
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
        sudo apt upgrade
    else
        echo "user aborded."
    fi
}

encryptor(){
    echo "---enCRYption---"
    echo "$1"
}

decryptor(){
    echo "---deCRYption---"
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

version(){
    echo "Version : $version"
}

developer(){
    echo "Developed by : $developer"
}

if [ $# == 0 ]; then
    echo "[-h, --help] for usage."
    echo "[-v, --version] check version."
else
    case "$1" in

	-h | --help) usage ;; 
    -v | --version) version ;;
    -e | --encrypt) encryptor $2 ;;
    -d | --decrypt) decryptor $s ;;
	-b | --brightness) brightness $2 ;; 
	-i | --internet) internet ;; 
    -u | --update) update ;;
    -z | --zip) zipper $* ;;
	*) echo "Option $1 not recognized" ;;

	esac
fi