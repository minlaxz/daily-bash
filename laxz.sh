#!/bin/bash
version='1.0.0' ;
developer='minlaxz' ;
usage(){
    echo "------------NonRoot------------";
    echo "-h , --help , print this help message and exit." ;
    echo "-b, --brightness, change screen brightness (0.5 to 1.3)." ;
    echo "-i , --internet , check internet connection." ;
    echo "-z, --zip, zip any given {file(s)} {folder(s)}." ;
    echo "-e, --encrypt, encrypt given {file} with aes256." ;
    echo "-d, --decrypt, decrypt laxz encrpyted {enc_file} aes256." ;
    echo "-rm, --remove, safe remove to .trash unlike built-in `rm`." ;
    echo "-----------Root-----------------";
    echo "-u, --update , pkg update and upgrade." ;
    echo "-m, --mount, mount a network's samba drive."
}

internet(){
    echo -e "Checking internet connection ..." ;
    wget -q --spider http://example.com ;
    if [ $? -eq 0 ] ; 
    then echo "Internet connection is -Noice-." ;
    else echo -e "No Internet Connection!" ;
    exit 0 ; fi
}


brightness(){
    if [[ $1 == "" || $1 < 0.5 || $1 > 1.3 ]]; 
    then echo "brightness $1 {value error}."; 
    else
    port=$(xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1);
    echo "Port is detected : $port";
    xrandr --output $port --brightness $1;
    echo "set.";
    fi;
}

update(){
    if [ $(id -u) != "0" ] ;
    then echo "Please run 'update option' as root" ;
    else sudo apt update ;
    read -p 'do you want to upgrade: y/n ' uservar ;
        if [ $uservar -eq 'y' ];
        then sudo apt upgrade ;
        else echo "user aborded." ; fi;
    fi;
}

encryptor(){
    echo "---enCRYption---" ;
    echo "$1" ;
}

decryptor(){
    echo "---deCRYption---" ;
    echo "$1" ;
}

zipper(){
    timenow=$(date +"%Y-%m-%d-%T") ;
    echo "---zip---" ;
    zip -r /home/$USER/laxz-$timenow.zip "$@" ;
    read -p 'do you want to encrypt: y/n ' uservar ;
    if [ $uservar == 'y' ];
    then encryptor /home/$USER/laxz-$timenow.zip ; fi
}

remover(){
    mv "$@" /home/$USER/.trash ;
    echo "removed to Trash." ;
}

mounter(){
    if [ $(id -u) != "0" ] ;
    then echo "Please run 'update option' as root" ;
    else
        if [ $1 != "" ] ; then
        mountpoint=$1
        sudo mount.cifs //192.168.0.10/samba_share $mountpoint -o user=laxzs,rw,pass=laxzsmb
        else
        echo "Specify the mount point."
        fi;
    fi;
}

version(){
    echo "Version : $version" ;
}

developer(){
    echo "Developed by : $developer" ;
}

if [ $# -eq 0 ]; then
    echo "[-h, --help] for usage." ;
    echo "[-v, --version] check version." ;
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
    -m | --mount) mounter $2 $3;;
    -rm | --remove) remover $* ;;
	*) echo "Option $1 not recognized" ;;

	esac
fi