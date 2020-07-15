#!/bin/sh
# this is coded by minlaxz `github.com/minlaxz`
# you can change whatever you want to!
# cuDNN CUDA Nvidia -> https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html#installlinux-tar
set -e

laxz_path=$HOME/.local/share/laxz
laxz_tmp=$laxz_path/tmp
hss_path=$laxz_path/hss

do_exit_tasks() {
    if [[ -d $laxz_tmp ]]; then
        rm -rvf $laxz_tmp && echo "cleaned."
    fi
}

cuda_install() {
    echo "cuda installation."
    if [ -z $(sudo dpkg -l | grep Nvidia)]; then
        echo "Nvidia driver not found!"
        echo "[check driver]: sudo dpkg -l | grep Nvidia"
        echo "[check hardware]: lspci | grep -i nvidia"
    fi
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
    sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
    sudo apt update
    sudo apt install cuda
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >>$laxz_tmp/activate
    echo "export PATH=/usr/local/cuda-11.0/bin${PATH:+:${PATH}}" >>$laxz_tmp/activate
}

cudnn_install() {
    echo "cudnn installation."
    wget https://black-moon-3dba.gdindex-laxz.workers.dev/cuDNNv7.6.4Sep2719CUDA10.1/cudnn-10.1-linux-x64-v7.6.4.38.tgz
    tar -xzvf cudnn-10.1-linux-x64-v7.6.4.38.tgz
    sudo mv cuda/include/cudnn*.h /usr/local/cuda/include
    sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
    sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
    sudo rm -rf ./cuda
}

opencv_install() {
    echo "installing required build dependencies."
    sudo apt install cmake gcc g++ git ffmpeg
    echo "to support python3."
    sudo apt install python3-dev python3-numpy
    echo "GTK support for GUI features, Camera support (v4l), Media Support (ffmpeg, gstreamer) etc."
    sudo apt install libavcodec-dev libavformat-dev libswscale-dev
    sudo apt install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
    echo "to support gtk3"
    sudo apt install libgtk-3-dev
    echo "optional Dependencies"
    sudo apt install libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev

    echo "Downaloading openCV..."
    git clone https://github.com/opencv/opencv.git
    cd opencv && mkdir build && cd build
    cmake ../
    make -j2
    sudo make install
    echo "https://github.com/pjreddie/darknet/issues/1886#issuecomment-547668240 > "
    sudo apt install libopencv-dev
    echo "opencv version: "
    python3 -c "import cv2 as cv; print(cv.__version__)"
    echo "you can install opencv in conda env _python_."
    echo "conda create --name mlearn python=3 && conda activate mlearn && pip install opencv-python"
}

miniconda_install() {
    echo "Miniconda installation."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod a+x ./Miniconda3-latest-Linux-x86_64.sh
    sh ./Miniconda3-latest-Linux-x86_64.sh
}

# activate_for_ml() {
#     echo "cudnn, cuda will be only ava in this session only"
#     source /home/$USER/.laxz_ml_profile
# }

# workspace_fix() {
#     #detail in `laxz-dilemma`
#     gsettings set org.gnome.shell.app-switcher current-workspace-only true
#     gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
# }

installOne() {
    sudo apt install build-essentials net-tools \
        cmake gcc g++ python3-dev git \
        vim curl wget \ 
}

installTwo(){
    sudo apt install xsel imwheel gvfs-fuse kazam exfat-fuse
    echo "install vbox, viber, slack, telegram, gnome-tweak-tool, chrome-gnome-shell"
    echo "https://extensions.gnome.org/extension/779/clipboard-indicator/"
    echo "https://extensions.gnome.org/extension/690/easyscreencast/"
    echo "https://extensions.gnome.org/extension/750/openweather/"
    echo "https://extensions.gnome.org/extension/708/panel-osd/"
    echo "https://extensions.gnome.org/extension/234/steal-my-focus/"
    echo "ZSH installation."
    sudo apt install zsh curl
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i "s/plugins=[^ ]*/plugins=(git zsh-autosuggestions)/" /home/$USER/.zshrc
    miniconda_install
}

installThree(){
    echo "This may take several minutes."
    # opencv_install
    # cuda_install
    # cudnn_install
}

software_installer() {
    echo ""
    echo "--install options--"
    echo ""
    echo "laxz)    --laxz's sys handler" #
    echo "one)     --general dependencies" ##
    echo "two)     --setup for general workspace" #
    echo "three)   --setup for machine learning"
    echo "menu)    --back to main menu."
    echo ""
    read -p "choose what do you want to install: " userChoice
    case "$userChoice" in 
    laxz)
        echo "laxz installation is still building."
        ;;
    one)
        echo "installing general dependencies."
        installOne
        ;;
    two)
        echo "Workspace installation."
        installTwo
        ;;
    three)
        echo "Machine Learning Workplace Installation."
        installThree
        ;;
    *)
        echo "not an option."
    esac

}

service_installer() {
    echo "service installer."
}

hss_installer(){
    if [[ ! -d $hss_path ]]; then
    mkdir $hss_path
    echo "folder created: $hss_path"
    fi
    echo ""
    echo "--- Handled by HSS> ---"
    echo ""
    echo -e "1) -e    --expose\e[1;31m        to expose 22-tcp to 'laxz' \e[0m"
    echo "2) -r    --return        return to software installation menu."
    echo "3) -x    --setup         smart mirror project."
    echo ""
    read -p "Please choose an option: " hssChoice

    case "$hssChoice" in
    -e | --expose | 1)
        if [[ ! -f $hss_path/ngrok ]]; then
        wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz -O $hss_path/ngrok-arm64.tgz
        tar -xzvf $hss_path/ngrok-arm64.tgz -C $hss_path/
        rm $hss_path/ngrok-arm64.tgz
        fi
        echo "exposing ssh tcp connection - 22 ."
        $hss_path/ngrok tcp 22
    ;;
    -r | --return | 2) master_installer;;
    -x | --setup | 3)
        echo "should I setup this one? OR you just give me tcp access to this rpi."
        echo "checking required dependencies"
        echo "cpu version: $(uname -m)"
        wget https://nodejs.org/dist/v12.18.2/node-v12.18.2-linux-armv7l.tar.xz -O $hss_path/node-v12.18.2-armv7l.tar.xz
        tar -xvf $hss_path/node-v12.18.2-armv7l.tar.xz -C $hss_path/
        sudo cp -R $hss_path/node-v12.18.2-linux-armv7l/* /usr/local/
        echo "node version: $(node -v)"
        echo "npm version: $(npm -v)"
        echo "Nodejs INSTALLED..."
        sudo apt install git ffmpeg
        echo "git INSTALLED..."
        cd $HOME
        git clone https://github.com/MichMich/MagicMirror.git && cd MagicMirror && sudo npm install
        cd $HOME
        git clone git@github.com:HackerHouseYT/AI-Smart-Mirror.git
        cp -r ./AI-Smart-Mirror/magic_mirror ./MagicMirror/modules/
        cp ./AI-Smart-Mirror/magic_mirror/config.js ./MagicMirror/config/
        sudo apt install ruby-full
        echo "Ruby INSTALLED..."
        sed -i "s/virtualenv\ hhsmartmirror/virtualenv\ hssmartmirror/" ./AI-Smart-Mirror/setup.sh
        sed -i "s/source\ .hhsmartmirror\/bin\/activate/source\ .hssmartmirror\/bin\/activate/" ./AI-Smart-Mirror/setup.sh
        sudo ./AI-Smart-Mirror/setup.sh
    ;;
    *)
        echo "abort, <$hssChoice> is not an option."
        fortune | cowthink
        hss_installer
    ;;
    esac
}

master_installer() {
    echo ""
    echo "what I can do -- "
    echo "1)-sf      --software        call software installer."
    echo "2)-sv      --service         call service installer."
    echo "3)-hss     --htarshwesin     for Htar Shwe Sin, rpi."
    echo "4)-r       --return          return to main menu and exit."
    read -p "which do you want to install: " userChoice
    case "$userChoice" in
    -sf | 1 | --software)
        echo "handling over to software installer."
        software_installer
        ;;
    -sv | 2 | --service)
        echo "handling over to service installer."
        service_installer
        ;;
    -hss | 3 | --htarshwesin)
        echo "handling over to HSS installer."
        sudo apt install fortune cowsay -qqq #or -qq>/dev/null
        hss_installer
    ;;
    -r | 4 | --return)
        echo "return to main menu."
        main
        ;;
    *)
        echo "abort, <$userChoice> not an option."
        master_installer
        ;;
    esac

}

master_uninstaller() {
    echo "still ongoing. TODO"
    #rm -rvf $laxz_path
}

main() {
    echo ""
    echo -e "\e[1;31m--Welcome to laxz--\e[0m"
    echo ""
    echo "1)-i  --install        install required softwares or services."
    echo "2)-u  --uninstall      uninstall..."
    echo "3)-e  --adios          exit and clean everything."
    echo ""
    read -p "choose an option: " opt
    #options=("install" "uninstall" "Adios")
    #PS3="choose an option:1/2/3:"
    #select opt in "${options[@]}"; do
    case "$opt" in
        -i | 1 | --[iI]* )
            master_installer
            ;;
        -u | 2 | --[uU]* )
            master_uninstaller
            ;;
        -e | 3 | --[Aa]* )
            # echo "you chose $REPLY which is $opt !" 
            echo '("Exit")'
            #do_exit_tasks
            #break
            ;;
        *)
            echo " choose an option: 1 or 2 or 3 "
            echo "visit https://minlaxz.web.app/init.html for detail."
            echo "Not an option <$opt>."
            ;;
        esac
    #done
}
main