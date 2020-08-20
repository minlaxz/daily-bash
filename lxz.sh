#!/bin/bash

prefix=$HOME/.local/share/lxz.gosh
lxz_tmp=$lxz_path/tmp
config_file=$prefix/lxz_config
AESKEY=$prefix/symme.key
iFunc=$prefix/iFunc.sh
now=$(date "+%Y-%m-%d-%T")
version='1.2.2' # version  -- [main.mijor.minor]
developer='minlaxz'

if [[ ! -f $config_file ]]; then
    touch $config_file
    echo "last_used=$now" >>$config_file
    echo "developer=$developer" >>$config_file
    echo "version=$version" >>$config_file
    echo "brightness=1" >>$config_file
    printf "CONFIG File created.\n"
fi

# printf "last used $last_used.\n"
sed -i "s/last_used=[^ ]*/last_used=$now/" $config_file
sed -i "s/version=[^ ]*/version=$version/" $config_file

source $config_file


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

generate_password(){
    length=$1
    printf "password: $(openssl rand -base64 $length)\n"
    printf "length: $length\n"
}
selfUpdate(){
    git -C $prefix pull https://github.com/minlaxz/daily-bash.git
}

if [ $# -eq 0 ]; then
    printf "[--help] for usage.\n"
    printf "[--version] check version.\n"
else
    stVar=$1 #**variable handling**
    ndVar=$2
    rdVar=$3
#TODO convert/ version 1.0.4
    case "$stVar" in
    -ff | --ffmpeg) stVar="--ffmpeg";;
    -hw | --hardware) stVar="--hardware" ;;
    -nw | --network) stVar="--network" ;;
    -cry| --crytography) stVar="--crytography" ;;
    -ex | --expose) stVar="--expose" ;;
    --help) stVar="--help" ;;
    --version) stVar="--version" ;;
    --developer) stVar="--developer" ;;
    --thanks) stVar="--thanks" ;;
    --reset) stVar="--reset" ;;

    *) printf "[--help] for usage.\n" ;;
    esac

    case "$stVar" in
    --help) bash $prefix/global-help.sh ;;
    --version) printf "$version\n" ;;
    --update) selfUpdate ;;
    --developer)
        echo -e "\a"
        notify-send 'hidden option' 'Developed by minlaxz'
        if [[ $ndVar == --[hH]* ]]; then
            bash $prefix/global-help.sh $stVar
        fi
        ;;
    --reset) printf "Reset laxz.\n" ;;
    ###PERMANENT###
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
            -i | --internet)  bash $iFunc $stVar "--internet" ;;
            -s | --speed) bash $iFunc $stVar "--speed" ;;
            *) 
            printf "\-i \-s \n"
            errOut $stVar $ndVar ;;
            esac
        fi
        ;;
    --crytography)
        if [[ $ndVar == --[hH]* || $ndVar == "" ]]; then
            bash $prefix/global-help.sh $stVar
        else
            case "$ndVar" in
            -e | --encrypt) printf "encryption" ;;
            -d | --decrypt) printf "decryption" ;;
            *) printf "not an option for cryptography" ;;
            esac
        fi
        ;;
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
    --timer)
        printf "setting a timer.\n"
        if [[ $ndVar == --[hH]* ]]; then
            bash $prefix/global-help.sh $stVar
        elif [[ $ndVar == "" ]]; then
            errOut $stVar $ndVar
        else
            python3 $prefix/timer.py --timer $ndVar
        fi
        ;;
    --generate)
        if [[ $ndVar == --[hH]* ]]; then
            bash $prefix/global-help.sh $stVar
        elif [[ $ndVar == "" || $ndVar==16 ]]; then
            printf "$ndVar\n"
            pw=$(openssl rand -base64 16)
            printf "$pw\n"
        else
            generate_password $ndVar
        fi
        
        ;;
    --thanks)
        bash $prefix/thanks.sh
        ;;
    esac
fi
