#!/bin/bash
version='1.0.0' ;
developer='minlaxz :>' ;
thispath=/home/$USER/git-in-sync/daily-bash/

usage(){
    echo "-h, --help, print this help message and exit." ;
    echo "-v, --version, print version."
    echo "------------NonRoot------------";

    echo "-k, --kit, handle the hardware parts"; # (0.5 to 1.3)." ;
    echo "-n, --network, handle the networks." ;

    echo "-z, --zip, zip any given {file(s)} {folder(s)}." ;
    echo "-e, --encrypt, encrypt given {file} with aes256." ;
    echo "-d, --decrypt, decrypt laxz encrpyted {enc_file} aes256." ;

    echo "-rm, --remove, safe remove to .trash unlike built-in 'rm'." ;
    echo "-v, --virtual, virtual machine options.";

    echo "-----------Root-----------------";
    echo "-p, --pkg, pkg update and upgrade." ;
    echo "-m, --mount, mount a network's samba drive.";
    echo "-l, --list, list installed packages.";
}

update(){
    if [ $(id -u) != "0" ] ;
    then echo "Please run 'update option' as root" ;
    else sudo apt update ;
        read -p "Do you want to upgrade? : y/n " uservar ;
        case $uservar in
            [Yy]*) sudo apt upgrade ;; #break
            #laxz.sh: line 48: break: only meaningful in a `for', `while', or `until' loop
            #[Nn]*) exit;;
            *) echo "Upgrade aborded." ;;
        esac
        #     while true; do
        #     read -p "Do you wish to install this program?" yn
        #     case $yn in
        #         [Yy]* ) make install; break;;
        #         [Nn]* ) exit;;
        #         * ) echo "Please answer yes or no.";;
        #     esac
        # done
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
    read -p "do you want to encrypt: y/n " uservar ;
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

list_installed(){
    sudo dpkg-query -Wf '${Installed-size}\t${Package}\n' | column -t
}


version(){
    echo "Version : $version" ;
}

developer(){
    notify-send 'Developed by' 'minlaxz'
    echo "Developed by : $developer" ;
}

if [ $# -eq 0 ]; then
    echo "[-h, --help] for usage." ;
    echo "[-v, --version] check version." ;
else
    case "$1" in
        
        -h | --help) usage ;;
        -V | --version) version ;;
        --developer) developer ;;

        -e | --encrypt) encryptor $2 ;;
        -d | --decrypt) decryptor $s ;;
        -z | --zip) zipper $* ;;

        -k | --kit) bash $thispath/sys-dev.sh $2 ;;
        -n | --network) bash $thispath/network-handling.sh ;;
        -p | --pkg) bash $thispath/package-handling.sh ;;
        -v | --virtual) bash $thispath/vm-handling.sh ;;

        
        -m | --mount) mounter $2 ;;
        -rm | --remove) remover $* ;;
        
        -l | --list) list_installed ;;
        *) echo "Option $1 not recognized" ;;
        
    esac
fi