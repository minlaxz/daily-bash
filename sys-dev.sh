monitor_brightness(){
    if [[ $1 == "" || $1 < 0.5 || $1 > 1.3 ]];
    then echo "brightness $1 {value error}.";
    else
        port=$(xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1);
        echo "Port is detected : $port";
        xrandr --output $port --brightness $1;
        echo "set.";
    fi;
}
init(){
    PS3="Options for hardware : "
    options=("monitor" "resource" "Adios")
    
    select opt in "${options[@]}"
    do
        case $opt in
            "monitor")
                read -p 'set brightness 0.5 ~ 1.3 : ' brightness ;
                monitor_brightness $brightness; break;;
            "resource")
                echo "#TODO" ;;
            "Adios" | "q")
                clear
                echo "you chose choice $REPLY which is $opt !" '("Exit")'
                break
            ;;
            *) echo "invalid option $REPLY"; break;;
        esac
    done
}
init
# init $1