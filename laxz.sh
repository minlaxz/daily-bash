#!/bin/bash

prefix=/home/$USER/git-in-sync/workspace-bash/daily-bash
config_file=$prefix/laxz_config
AESKEY=$prefix/symme.key
iFunc=$prefix/iFunc.sh
now=$(date "+%Y-%m-%d-%T")
version='1.1.3'
developer='minlaxz'

if [[ ! -f $config_file ]]; then
    touch $config_file
    echo "last_used=$now" >>$config_file
    echo "developer=$developer" >>$config_file
    echo "version=$version" >>$config_file
    echo "brightness=1" >>$config_file
    printf "CONFIG File created.\n"
fi
source $config_file

printf "last used $last_used.\n"
sed -i "s/last_used=[^ ]*/last_used=$now/" $config_file

errOut() {
    errFlag=$1
    errOpt=$2
    errReason=$3

    printf "Not an option.\n"
    printf "laxz $errFlag --help\n"
}

integrity() {
    printf "Original : $2 , CHECKSUM : $1 \n"
    printf "Modified : $4 , CHECKSUM : $3 \n"
}

zipper() {
    timenow=$(date +"%Y-%m-%d-%T")
    printf "zipping---"
    zip -r /home/$USER/laxz-$timenow.zip "$@"
    read -p "do you want to encrypt: y/n " uservar
    if [ $uservar == 'y' ]; then
        encryptor /home/$USER/laxz-$timenow.zip
    else
        printf "Cancel."
    fi
}

mounter() {
    if [ $(id -u) != "0" ]; then
        printf "Please run 'update option' as root"
    else
        if [ $1 != "" ]; then
            mountpoint=$1
            sudo mount.cifs //192.168.0.10/samba_share $mountpoint -o user=laxzs,rw,pass=laxzsmb
        else
            printf "Specify the mount point."
        fi
    fi
}

sync() {
    port=$(xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1)
    xrandr --output $port --brightness $brightness
    printf "all set."
}

if [ $# -eq 0 ]; then
    printf "[--help] for usage.\n"
    printf "[--version] check version.\n"
else
    stVar=$1 #**variable handling**
    ndVar=$2
    rdVar=$3

    case "$stVar" in
    -hw | --hardware) stVar="--hardware" ;;
    -ec | --encrypt) stVar="--encrypt" ;;
    -dc | --decrypt) stVar="--decrypt" ;;
    -nw | --network) stVar="--network" ;;
    -zz | --zip) stVar="--zip" ;;
    # -pk | --package) stVar="--package" ;;
    # -vm | --virtual) stVar="--virtual" ;;
    # -mn | --mount) stVar="--mount" ;;
    -rm | --remove) stVar="--remove" ;;
    -cp | --copy) stVar="--copy" ;;
    -ex | --expose) stVar="--expose" ;;
    --help) stVar="--help" ;;
    --version) stVar="--version" ;;
    --reset) stVar="--reset" ;;
    --status) stVar="--status" ;;
    --sync) stVar="--sync" ;;
    --thanks) stVar="--thanks" ;;
    --developer) stVar="--developer" ;;
    *) printf "[--help] for usage.\n" ;;
    esac

    case "$stVar" in
    --help) bash $prefix/global-help.sh ;;
    --version) printf "$version\n" ;;
    --developer)
        echo -e "\a"
        notify-send 'hidden option' 'Developed by minlaxz'
        if [[ $ndVar == --[hH]* ]]; then
            bash $prefix/global-help.sh $stVar
        fi
        ;;
    --reset) printf "Reset laxz.\n" ;;
    --status) printf "Brightess is $brightness\n" ;;
    --sync)
        xrandr --output $(xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1) --brightness $brightness
        printf "all settings in sync.\n"
        ;;
    --test)
        printf "third arg is : ${!3}\n"
        #printf "third arg is : ${@:3}"
        ;;
    --expose)
        if [[ $ndVar == --[hH]* ]]; then
            bash $prefix/global-help.sh $stVar
        elif [[ $ndVar == "" ]]; then
            errOut $stVar $ndVar
        else
            case "$ndVar" in
            -[sS]*)
                bash $iFunc $stVar "--service"
                ;;
            -[fF]*)
                bash $iFunc $stVar "--filesystem"
                ;;
            *)
                errOut $stVar $ndVar
                ;;
            esac
        fi
        ;;
    --encrypt)
        if [[ $ndVar == --[hH]* || $ndVar == "" ]]; then
            bash $prefix/global-help.sh $stVar
        else
            bash $iFunc $stVar $ndVar
        fi
        ;;
    --decrypt)
        if [[ $ndVar == --[hH]* || $ndVar == "" ]]; then
            bash $prefix/global-help.sh $stVar
        else
            bash $iFunc $stVar $ndVar
        fi
        ;;
    --zip) zipper $* ;;

    --hardware)
        if [[ $ndVar == --[hH]* || $ndVar == "" ]]; then
            bash $prefix/global-help.sh $stVar
        else
            case "$ndVar" in
            -m | --monitor)
                bash $iFunc $stVar "--monitor" $rdVar
                ;;
            *)
                #not controlable hardware part.
                errOut $stVar $ndVar
                ;;
            esac
        fi
        ;;

    --network)
        if [[ $ndVar == --[hH]* ]]; then
            bash $prefix/global-help.sh $stVar
        elif [[ $ndVar == "" ]]; then
            errOut $stVar $ndVar
        else
            case "$ndVar" in
            -i)  bash $iFunc $stVar "--internet" ;;
            -s) bash $iFunc $stVar "--speed" ;;
            *) 
            printf "\-i \-s \n"
            errOut $stVar $ndVar ;;
            esac
        fi
        ;;
    --package) bash $prefix/package-handling.sh ;;
    --virtual) bash $prefix/vm-handling.sh ;;
    --remove)
        printf "remove function with pain in ass safe.\n"
        if [[ $(apt list --installed trash-cli 2>/dev/null | wc -l) == 1 ]]; then
            sudo apt install trash-cli
        else
            #trash-put "$@"
            trash-put "$2"
        fi
        printf "removed to Trash.\n"
        ;;
    --copy)
        printf "copy function with progress verbose.\n"
        if [[ $3 == "" ]]; then
            printf "insuffcient argument.\n"
        else
            rsync -ah --progress $2 $3
        fi
        ;;
    --thanks)
        bash $prefix/thanks.sh
        ;;
    esac
fi
