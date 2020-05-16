#!/bin/bash

prefix=/home/$USER/git-in-sync/workspace-bash/daily-bash
config_file=$prefix/laxz_config
source $config_file

now=$(date "+%Y-%m-%d-%T")
printf "last used $last_used.\n"
sed -i "s/last_used=[^ ]*/last_used=$now/" $config_file

AESKEY=$prefix/symme.key

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

iFunc() {
    flag=$1
    value=$2
    case "$flag" in
    --monitor)
        #error -1, >= 10
        if [[ $value == "" || $value < 0.5 || $value > 1.3 ]]; then #|| $value =~ ^[-+]?[0-9]+$
            printf "brightness $value {value error}."
        else
            if [[ $brightness == $value ]]; then
                printf "Brightness is already set to <$value>."
            else
                printf "previous brightness : $brightness"
                printf "current brightess : $value"
                port=$(xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1)
                printf "port detected : $port"
                xrandr --output $port --brightness $value
                sed -i "s/brightness=[^ ]*/brightness=$value/" $config_file
                printf "all set."
            fi
        fi
        ;;
    --expose)
        #thanks http://serveo.net/
        case "$value" in
        --service)
            printf "Service eXposing."
            read -p "22, 80, 8887 to expose? : " uservar
            case "$uservar" in
            22)
                printf "ssh -J serveo.net username@laxzhome"
                ssh -R laxzhome:22:localhost:22 serveo.net
                ;;
            80) ssh -p 443 -R laxzhome:80:localhost:80 serveo.net ;;
            8887) ssh -R laxzhome:80:localhost:8887 serveo.net ;;
            *) printf "error\n" ;;
            esac
            printf "port $uservar exposed.\n"
            ;;
        --filesystem)
            printf "Files eXposing"
            ;;
        *) printf "[iFunc:expose] internel error." ;;
        esac
        ;;
    --encrypt)
        org_file=$value
        if [[ ! -f $org_file ]]; then
            printf "404.\n"
            printf "laxz --encrypt --help for usage.\n"
        
        else
            printf "enCRYption---\n"
            printf "encrypting file : '$org_file' with aes-256."
            read -p "encrypt with (p)assword or (k)eyfile ? : " uservar
            case $uservar in
            [Pp]*)
                #Password
                openssl aes-256-cbc -salt -pbkdf2 -in $org_file -out $org_file.loc
                integrity $(sha256sum $org_file) $(sha256sum $org_file.loc)
                printf "enCRYption Done."
                ;;

            [Kk]*)
                #keyfile
                if [ ! -f $AESKEY ]; then
                    printf "AESKey not found!\nGenerating new one.\n"
                    openssl rand 256 >symme.key
                    openssl enc -aes-256-cbc -salt -pbkdf2 -in $org_file -out $org_file.los -k $AESKEY
                else
                    openssl enc -aes-256-cbc -salt -pbkdf2 -in $org_file -out $org_file.los -k $AESKEY
                fi
                integrity $(sha256sum $org_file) $(sha256sum $org_file.locs)
                printf "enCRYption Done."
                ;;

            *) printf "Aborded." ;;
            esac
        fi
        ;;
    --decrypt)
        locked_file=$value
        if [[ ! -f $locked_file ]]; then
            printf "404.\n"
            printf "laxz --decrypt --help for usage.\n"
        elif [[ ${locked_file: -4} == ".loc" ]]; then
        printf "deCRYption---\n"
            printf "encrypted with PASSWORD\n"
            openssl aes-256-cbc -d -salt -pbkdf2 -in $locked_file -out ${locked_file/.loc/}
            integrity $(sha256sum $locked_file) $(sha256sum ${locked_file/.loc/})
        elif [[ ${locked_file: -4} == ".los" ]]; then
        printf "deCRYption---\n"
            printf "encrypted with KEY_FILE\n"
            if [ ! -f $AESKEY ]; then
                printf "THIS IS FETAL, NO AES_KEY FOUND TO UNLOCK!\n"
                printf "make sure 'symme.key' is configured in config.\n"
            else
                openssl enc -aes-256-cbc -d -salt -pbkdf2 -in $locked_file -out ${locked_file/.locs/} -k $AESKEY
                integrity $(sha256sum $locked_file) $(sha256sum ${locked_file/.locs/})
            fi
        else
            printf "\n----"
            printf "[Fetal] : NOT locked by laxz.\n----\n"
        fi
        ;;
    *)
        printf "[iFunc] internal error"
        ;;
    esac
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
    main_var=$1 #variable handling**
    case "$main_var" in
    -hw | --hardware) main_var="--hardware" ;;
    -ec | --encrypt) main_var="--encrypt" ;;
    -dc | --decrypt) main_var="--decrypt" ;;
    -nw | --network) main_var="--network" ;;
    -zz | --zip) main_var="--zip" ;;
    -pk | --package) main_var="--package" ;;
    -vm | --virtual) main_var="--virtual" ;;
    -mn | --mount) main_var="--mount" ;;
    -rm | --remove) main_var="--remove" ;;
    -cp | --copy) main_var="--copy" ;;
    -ex | --expose) main_var="--expose" ;;
    --help) main_var="--help" ;;
    --version) main_var="--version" ;;
    --reset) main_var="--reset" ;;
    --status) main_var="--status" ;;
    --sync) main_var="--sync" ;;
    *) printf "[--help] for usage.\n" ;;
    esac

    case "$main_var" in
    --help) bash $prefix/global-help.sh ;;
    --version) printf "$version\n" ;;
    --developer)
        echo -e "\a"
        notify-send 'hidden option' 'Developed by minlaxz'
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
        if [[ $2 == --[hH]* ]]; then #if [[ $2 == -[hH]* || $2 == --[hH]* ]]; then
            bash $prefix/global-help.sh $main_var
        elif [[ $2 == "" ]]; then
            printf "[expose-e1] -> invalid. see laxz --expose --help\n"
        else
            case "$2" in
            -[sS]*)
                sub_var="--service"
                iFunc $main_var $sub_var
                ;;
            -[fF]*)
                sub_var="--filesystem"
                iFunc $main_var $sub_var
                ;;
            *) printf "[expose-e2] -> invalid. see laxz --expose --help\n" ;;
            esac
        fi
        ;;
    --encrypt)
        if [[ $2 == --[hH]* ]]; then
            bash $prefix/global-help.sh $main_var
        else
            iFunc $main_var $2
        fi
        ;;
    --decrypt)
        if [[ $2 == --[hH]* ]]; then
            bash $prefix/global-help.sh $main_var
        else
            iFunc $main_var $2
        fi
        ;;
    --zip) zipper $* ;;

    --hardware)
        if [[ $2 == "" ]]; then
            bash $prefix/hardware-handling.sh
        else
            case "$2" in
            -m | --monitor)
                if [[ $3 == "" ]]; then
                    read -p "set brightness 0.5 ~ 1.3 : " br
                    iFunc $2 $br
                else
                    iFunc $2 $3
                fi
                ;; ##EXTENSIBLE
            *)
                printf "$2 is invalid for $1."
                ;;
            esac
        fi
        ;;
    --network)
        if [[ $2 == "" ]]; then
            bash $prefix/network-handling.sh
        else
            case "$2" in
            -if)
                case "$3" in
                en) ifconfig eno1 | grep inet ;;
                do) ifconfig docker0 | grep inet ;;
                lo) ifconfig lo | grep inet ;;
                esac
                ;;
            *)
                printf "invalid"
                ;;
            esac
        fi
        ;;
    --package) bash $prefix/package-handling.sh ;;
    --virtual) bash $prefix/vm-handling.sh ;;
    --mount) mounter $2 ;;
    --remove)
        printf "remove function with pain in ass safe."
        if [[ $(apt list --installed trash-cli 2>/dev/null | wc -l) == 1 ]]; then
            sudo apt install trash-cli #Thanks https://github.com/andreafrancia/trash-cli
        else
            #printf $2
            #trash-put "@$"
            trash-put "$2"
        fi
        printf "removed to Trash."
        ;;
    --copy)
        printf "copy function with progress verbose."
        if [[ $3 == "" ]]; then
            printf "insuffcient argument."
        else
            rsync -ah --progress $2 $3
        fi
        ;;
    esac
fi
