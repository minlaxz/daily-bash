internet(){
    clear
    echo -e "Checking internet connection ..." ;
    wget -q -T 1 --spider http://example.com ;
    if [ $? -eq 0 ] ;
    then echo "Internet connection is -Noice-." ;
    else echo -e "No Internet Connection!" ;
    fi
}

init(){
    PS3="Options for network : "
    options=("internet" "port" "Adios")
    
    select opt in "${options[@]}"
    do
        case $opt in
            "internet")
            internet ; break;;
            "port")
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