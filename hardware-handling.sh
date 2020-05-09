user_files=/home/$USER/git-in-sync/workspace-bash/daily-bash
config_file=$user_files/laxz_config
source $config_file

monitor_brightness(){
    if [[ $2 == "" || $2 < 0.5 || $2 > 1.3 ]];
    then echo "brightness $2 {value error}.";
    else
        xrandr --output $1 --brightness $2;
        sed -i "s/brightness=[^ ]*/brightness=$2/" $config_file
        echo "all set.";
    fi;
}
init(){
    PS3="Options for hardware : "
    options=("monitor" "resource" "Adios")
    
    select opt in "${options[@]}"
    do
        case $opt in
            "monitor")
                #echo "current brightness is " `cut -f 2 -d ' ' laxz_config`
                port=$(xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1);
                echo "port detected : $port";
                echo "current brightness : $brightness"
                read -p 'set brightness 0.5 ~ 1.3 : ' br ;
                monitor_brightness $port $br;
            break;;
            "resource")
                echo "#TODO" 
            break;;
            "Adios" | "q")
                clear
                echo "you chose choice $REPLY which is $opt !" '("Exit")'    
            break;;
            *) echo "invalid option $REPLY";
            break;;
        esac
    done
}
init
# init $1