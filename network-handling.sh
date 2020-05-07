internet(){
    clear
    echo -e "Checking internet connection ..." ;
    wget -q -T 1 --spider http://example.com ;
    if [ $? -eq 0 ] ;
    then echo "Internet connection is -Noice-." ;
    else echo -e "No Internet Connection!" ;
    fi
}

port_ip(){
    read -p "SCAN (p)ort or (i)paddress ? : " uservar
    case $uservar in 
        [pP]*)
        #port
        read -p "which port ? > default all LISTEN : " uservar
        if [ $uservar != "" ] ; then
        sudo lsof -i:$uservar
    #sudo ss -tulpn
    #sudo netstat -tupln | grep LISTEN
        else
        sudo lsof -i -P -n | grep LISTEN
        fi
        ;;

    [iI]*)
    #ip-address
    read -p "IPADDRESS : " uservar
    sudo nmap -sTU -O $uservar
    ;;
    
    *)
    echo "Aborded."
    ;;

esac


}

init(){
    PS3="Options for network : "
    options=("internet" "port-ipAddress-scan" "Adios")
    
    select opt in "${options[@]}"
    do
        case $opt in
            "internet")
            internet ; 
            break
            ;;
            "port-ipAddress-scan")
            port_ip ;
            ;;
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