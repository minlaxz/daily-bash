flag=$1
case "$flag" in
"")
    printf "       --help      print lxz help message and exit.\n"
    printf "       --version   print lxz version.\n"
    printf "       --reset     no lxz hagas esto.\n"
    printf "       --status    lxz status.\n"
    printf "       --sync      sync with all setting.\n\n"

    printf "/-fz    --file      check type of the file.\n"
    printf "/-cp    --copy      copy files and directories with progess verbose.\n"
    printf "/-rm    --remove    safe remove files and directories.\n\n"
    printf "/-cv    --convert   convert file types"

    printf "/-ex    --expose    EXPOSING local service or file-system to the Internet.\n"
    printf "/-hw    --hardware  handle the hardware parts.\n"
    printf "/-nw    --network   handle the networks.\n"
    printf "/-vm    --virtual   virtual machine options.\n"
    printf "/-zz    --zip       zip any given file(s) or folder(s).\n"
    printf "/-ec    --encrypt   encrypt given {file} with aes256.\n"
    printf "/-dc    --decrypt   decrypt lxz encrpyted {enc_file} aes256.\n"
    printf "/-pk    --package       package update and upgrade.\n"
    printf "/-mn    --mount     mount a network's samba drive.\n"
    printf "/-tm    --timer     set a timer for babysitting the colab kernel.\n"
    printf "/-genpw --generate  generate a password.\n"
    ;;
--expose)
    printf "\n"
    printf "[help]: lxz's Service Exposing.\n"
    printf "\n"
    printf "example[0]: lxz --expose -s<service or port> or -f<path> for passing iFunc.\n"
    printf "\n"

    ;;
--encrypt)
    printf "\n"
    printf "[help]: lxz's Encryptor.\n"
    printf "\n"
    printf "example[0]: lxz -ec {--ecrypt} filepath or directory\n"
    printf "\n"
;;
--decrypt)
    printf "\n"
    printf "[help]: lxz's Decryptor.\n"
    printf "\n"
    printf "example[0]: lxz -dc {--decrypt} file.loc or file.los\n"
    printf "\n"
;;
--network)
    printf "\n"
    printf "[help]: lxz's Network.\n"
    printf "\n"
    printf "example[0]: $ lxz -nw -i , check internet connection.\n"
    printf "example[1]: $ lxz -nw -s , check network speed.\n"
    printf "\n"
;;
--timer)
    printf "\n"
    printf "[help]: lxz's timer.\n"
    printf "\n"
    printf "example[0]: $ lxz -tm {int} , set a time out value.\n"
    printf "\n"
;;
--generate)
    printf "\n"
    printf "[help]: lxz's password generateor.\n"
    printf "\n"
    printf "example[0]: $ lxz -genpw -{length: 2,4,8,16... 2_pow_anything}\n"
    printf "\n"
;;
--hardware)
    printf "\n"
    printf "[help]: lxz's hardware help.\n"
    printf "\-m {value 0.5~1} =: monitor brightness."
    printf "\n"
;;
--update)
    printf "\n"
    printf "[help]: lxz's update.\n"
    printf "\n"
    ;;
*)
    printf "\n"
    printf "No help for $flag.\n"
    printf "\n"
;;
esac
