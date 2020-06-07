flag=$1
case "$flag" in
"")
    printf "       --help      print laxz help message and exit.\n"
    printf "       --version   print laxz version.\n"
    printf "       --reset     no laxz hagas esto.\n"
    printf "       --status    laxz status.\n"
    printf "       --sync      sync with all setting.\n\n"

    printf "/-fz    --file      check type of the file.\n"
    printf "/-cp    --copy      copy files and directories with progess verbose.\n"
    printf "/-rm    --remove    safe remove files and directories.\n\n"

    printf "/-ex    --expose    EXPOSING local service or file-system to the Internet.\n"
    printf "/-hw    --hardware  handle the hardware parts.\n"
    printf "/-nw    --network   handle the networks.\n"
    printf "/-vm    --virtual   virtual machine options.\n"
    printf "/-zz    --zip       zip any given file(s) or folder(s).\n"
    printf "/-ec    --encrypt   encrypt given {file} with aes256.\n"
    printf "/-dc    --decrypt   decrypt laxz encrpyted {enc_file} aes256.\n"
    printf "/-pk    --package       package update and upgrade.\n"
    printf "/-mn    --mount     mount a network's samba drive.\n"
    printf "/-tm    --timer     set a timer for babysitting the colab kernel.\n"
    printf "/-genpw --generate  generate a password.\n"
    ;;
--expose)
    printf "\n"
    printf "[help]: laxz's Service Exposing.\n"
    printf "\n"
    printf "example[0]: laxz --expose -s<service or port> or -f<path> for passing iFunc.\n"
    printf "\n"

    ;;
--encrypt)
    printf "\n"
    printf "[help]: laxz's Encryptor.\n"
    printf "\n"
    printf "example[0]: laxz -ec {--ecrypt} filepath or directory\n"
    printf "\n"
;;
--decrypt)
    printf "\n"
    printf "[help]: laxz's Decryptor.\n"
    printf "\n"
    printf "example[0]: laxz -dc {--decrypt} file.loc or file.los\n"
    printf "\n"
;;
--network)
    printf "\n"
    printf "[help]: laxz's Network.\n"
    printf "\n"
    printf "example[0]: $ laxz -nw -i , check internet connection.\n"
    printf "example[1]: $ laxz -nw -s , check network speed.\n"
    printf "\n"
;;
--timer)
    printf "\n"
    printf "[help]: laxz's timer.\n"
    printf "\n"
    printf "example[0]: $ laxz -tm {int} , set a time out value.\n"
    printf "\n"
;;
--generate)
    printf "\n"
    printf "[help]: laxz's password generateor.\n"
    printf "\n"
    printf "example[0]: $ laxz -genpw -{length: 2,4,8,16... 2_pow_anything}\n"
    printf "\n"
;;
*)
    printf "Internal ERROR.\n"
    printf "\n"
    printf "No help for $flag.\n"
    printf "\n"
;;
esac
