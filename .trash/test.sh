PS3='Please enter your choice: '
options=("list vms" "start a vm" "Option 3" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "list vms")
            echo "you chose choice 1"
            ;;
        "Option 2")
            echo "you chose choice 2"
            ;;
        "Option 3")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done