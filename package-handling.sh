modify(){
    echo "Modifier"
}

installed_func(){
    read -p "enter package_partial_name : " pkgname;
    if [ -n "$(apt list --installed | grep $pkgname)" ];
    then echo "That package is not installed";
    else
        echo "package info"
        apt list --installed | grep $pkgname;
        read -p "want to modify? y/n : " uservar ;
        case $uservar in
            [Yy]*) modify ;;
            *) echo "Aborded.";;
        esac
    fi
}

init(){
    PS3="Options for pkgs : "
    options=("installed" "update" "fix-broken" "Adios")
    
    select opt in "${options[@]}"
    do
        case $opt in
            "installed")
            installed_func ; break;;
            "update")
            echo "#TODO" ;;
            "fix-broken")
            echo "#TODO";;
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