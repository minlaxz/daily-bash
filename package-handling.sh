modify(){
    # PS3="Options for ,modifier : "
    # options=("")
    echo "I am modifier."
}

installed_func(){
    read -p "enter package_partial_name : " pkgname;
    if [ -z "$(apt list --installed | grep $pkgname)" ];
    then echo "That package is not installed $pkgname";
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

update_func(){
    sudo apt update
    if [ `id -u` != "0" ] ;
    then echo "Please run this options as root."
    else
        sudo apt update
        read -p "Do you want to upgrade y/n : " uservar;
        case $uservar in
            [Yy]*) sudo apt upgrade ;;
            *) echo "Aborded." ;;
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
            update_func ;;
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