#!/bin/bash
vm_controller(){
    echo "$1"
    echo "$2"
}
init(){
    echo "--- Existing VM ---"
    /usr/bin/vboxmanage list vms
    echo ""
    if [ -z "$(/usr/bin/vboxmanage list runningvms)" ] ;
    then echo "No Running VM. "
    else
        echo "--- Running VM ---"
        /usr/bin/vboxmanage list runningvms
    fi ;
    echo ""
    
    vm1="{b8197fcd-8c67-4d19-b420-dd17f98d7f52}"
    #TODO for vm(s)
    
    PS3="Choose option for $vm1 : "
    options=("start" "stop" "Adios")
    
    select opt in "${options[@]}"
    do
        case $opt in
            "start")
                #echo "you chose choice $REPLY which is $opt"
                if [ -z "$(/usr/bin/vboxmanage list runningvms)" ];
                then vm_controller $vm1 $opt;
                else echo "[control] VM is already Running." ;
                fi;
            ;;
            "stop")
                #echo "you chose choice $REPLY which is $opt"
                if [ -z "$(/usr/bin/vboxmanage list runningvms)" ];
                then echo "[control] No VM is running.";
                else vm_controller $vm1 $opt;
                fi;
            ;;
            "Adios" | "q")
                clear
                echo "you chose choice $REPLY which is $opt !" '("Exit")'
                break
            ;;
            *) echo "invalid option $REPLY";;
        esac
    done
    #/usr/lib/virtualbox/VBoxHeadless --startvm {b8197fcd-8c67-4d19-b420-dd17f98d7f52}
}

init