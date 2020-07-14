#!/bin/sh
# this is coded by minlaxz `github.com/minlaxz`
# you can change whatever you want to!
# cuDNN CUDA Nvidia -> https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html#installlinux-tar
set -e

laxz_path=$HOME/.local/share/laxz/
laxz_tmp=$laxz_path/tmp

do_exit_tasks() {
    if [[ -d $laxz_tmp ]]; then
        rm -rvf $laxz_tmp && echo "cleaned."
    fi
}

miniconda_install() {
    echo "Miniconda installation."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod a+x ./Miniconda3-latest-Linux-x86_64.sh
    sh ./Miniconda3-latest-Linux-x86_64.sh
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
activate_for_ml() {
    echo "cudnn, cuda will be only ava in this session"
    source /home/$USER/.laxz_ml_profile
}

workspace_fix() {
    #detail in `laxz-dilemma`
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
}

installOne() {
    sudo apt install build-essentials net-tools \
        cmake gcc g++ python3-dev git \
        vim curl wget \ 
}

installTwo(){
    sudo apt install xsel imwheel gvfs-fuse kazam exfat-fuse
    # echo "install vbox, viber, slack, telegram, gnome-tweak-tool, chrome-gnome-shell"
    # echo "https://extensions.gnome.org/extension/779/clipboard-indicator/"
    # echo "https://extensions.gnome.org/extension/690/easyscreencast/"
    # echo "https://extensions.gnome.org/extension/750/openweather/"
    # echo "https://extensions.gnome.org/extension/708/panel-osd/"
    # echo "https://extensions.gnome.org/extension/234/steal-my-focus/"
    echo "ZSH installation."
    sudo apt install zsh curl
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i "s/plugins=[^ ]*/plugins=(git zsh-autosuggestions)/" /home/$USER/.zshrc
    miniconda_install
}

installThree(){
    echo "This may take several minutes."
    opencv_install
    cuda_install
    cudnn_install
}

main_help() {
    echo "--help message--"
    echo ""
    echo "help      --show this super helpful message."
    echo "install   --install required softwares or services."
    echo "uninstall --uninstall..."
    echo "adios     --exit and clean everything."
    echo ""
}

sf_istaller_help() {
    echo "--install options--"
    echo ""
    echo "laxz    --laxz's sys handler" #
    echo "one     --general dependencies" ##
    echo "two     --setup for general workspace" #
    echo "three   --setup for machine learning"
    echo "menu    --back to main menu."
    echo "exit    --ctrl c or exit."
    echo "so on."
}

software_installer() {
    sf_istaller_help
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

installer() {
    echo "Main installer."
    echo ""
    echo "sf        --call software installer."
    echo "sv        --call service installer."
    echo "return    --return to main menu."
    read -p "which do you want to install: " userChoice
    case "$userChoice" in
    sf)
        echo "handling over software installer."
        software_installer
        ;;
    sv)
        echo "handling over service installer."
        service_installer
        ;;
    return)
        echo "return to main menu."
        main
        ;;

    *)
        echo "abort, <$userChoice> not an option."
        ;;
    esac

}

uninstaller() {
    echo "still ongoing. TODO"
    #rm -rvf $laxz_path
}

main() {
    echo "--Welcome to laxz--"
    options=("help" "install" "uninstall" "Adios")
    PS3="choose an option:1,2,3,4: "
    select opt in "${options[@]}"; do
        case "$opt" in
        "help")
            main_help
            ;;
        "install")
            installer
            ;;
        "uninstall")
            uninstaller
            ;;
        "Adios")
            echo "you chose choice $REPLY which is $opt !" '("Exit")'
            do_exit_tasks
            break
            ;;
        *)
            echo "visit https://minlaxz.web.app/init.html for detail."
            echo "laxz: Not an option <$REPLY>."
            ;;
        esac
    done
}
main
