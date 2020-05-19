flag=$1
value=$2
rd=$3

case "$flag" in
--hardware)
    case "$value" in
    --monitor)
        if [[ $rd == "" || $rd < 0.5 || $rd > 1.3 ]]; then
            printf "brightness $value {value error}.\n"
        else
            if [[ $brightness == $value ]]; then
                printf "Brightness is already set to <$value>.\n"
            else
                printf "previous brightness : $brightness"
                printf "current brightess : $value"
                port=$(xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1)
                printf "port detected : $port"
                xrandr --output $port --brightness $value
                sed -i "s/brightness=[^ ]*/brightness=$value/" $config_file
                printf "all set.\n"
            fi
        fi
        ;;
    esac
    ;;
--expose)
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
--network)
    case "$value" in
    --internet)
        echo -e "Checking internet connection ..."
        wget -q -T 2 --spider http://example.com
        if [ $? -eq 0 ]; then
            printf "Internet connection is -Noice-.\n"
        else
            printf -e "No Internet Connection.\n"
        fi
        ;;
    --speed)
        #https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
        if [[ $(apt list --installed speedtest-cli 2>/dev/null | wc -l) == 1 ]]; then
            printf "need to install lib.\n"
            sudo apt install speedtest-cli
            speedtest-cli
        else
            speedtest-cli
        fi
        ;;
    --info)
        if [[ $3 == "" ]]; then
            printf "card name required.\n"
            errOut $flag
        else
            case "$3" in
            en) ifconfig eno1 | grep inet ;;
            do) ifconfig docker0 | grep inet ;;
            lo) ifconfig lo | grep inet ;;
            *) errOut $stVar $ndVar ;;
            esac
        fi
        ;;
    esac
    ;;
*)
    printf "[iFunc] internal fatal error\n"
    printf "flag : $flag\n"
    printf "value : $value\n"
    ;;
esac
