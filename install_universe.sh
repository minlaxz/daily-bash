# by minlaxz `https://github.com/minlaxz/`
# cuDNN CUDA Nvidia Docs -> https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html#installlinux-tar

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
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> $laxz_tmp/activate
    echo "export PATH=/usr/local/cuda-11.0/bin${PATH:+:${PATH}}" >> $laxz_tmp/activate
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
    make -j4
    sudo make install
    echo "https://github.com/pjreddie/darknet/issues/1886#issuecomment-547668240 > "
    sudo apt install libopencv-dev
    echo "opencv version: "
    python3 -c "import cv2 as cv; print(cv.__version__)"
    echo "you can install opencv in _python_conda env."
    echo "conda create --name <name> python=3 && conda activate <name> && pip install opencv-python"
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

workspace_fix() {
    #also in `laxz-dilemma`
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
}

transparent_dock_install_conky(){
    #also in `laxz-dilemma`
    gsettings set org.gnome.shell.extensions.dash-to-dock customize-alphas true
    gsettings set org.gnome.shell.extensions.dash-to-dock min-alpha 0
    gsettings set org.gnome.shell.extensions.dash-to-dock max-alpha 0
    sudo apt install conky
    cp ./conkyDockrc $HOME/.conky/conkyDockrc
    cp ./conkyRrc $HOME/.conky/conkyRrc
    cp ./conky-startup.sh $HOME/.conky/conky-startup.sh
    cp ./conky-startup.sh.Desktop $HOME/.config/autostart/conky-startup.sh.Desktop
}

laxDE(){
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

mlWorkspace(){
    echo "This may take several minutes."
    # opencv_install
    # cuda_install
    # cudnn_install
}

jetsonvnc(){
    export DISPLAY=:0
    gsettings set org.gnome.Vino enabled true
    gsettings set org.gnome.Vino prompt-enabled false
    gsettings set org.gnome.Vino require-encryption false
    /usr/lib/vino/vino-server display=DISPLAY &
    echo "[Desktop Entry]" 
    echo "Type=Application"
    echo "Exec=systemctl --user start vino-server"
    echo "Hidden=false"
    echo "NoDisplay=false"
    echo "X-GNOME-Autostart-enabled=true"
    echo "Name=Vino Server"
    echo "Comment=Auto Start VNC Service"
.config/autostart/systemctl
}

general() {
    echo "Installing general dependencies."
    sudo apt install build-essentials net-tools \
        cmake gcc g++ python3-dev git \
        vim curl wget 

}

softwareInstaller() {
    helper --softwareInstaller
    read -p " what do you say < : " u
    case "$u" in 
    1) nvidia_install ;;
    2) cuda_install ;;
    3) cudnn_install ;;
    4) opencv_install ;;
    5) miniconda_install ;;
    r) main ;;
    b) mainInstall ;;
    x) exit_tasks;;
    *)
        softwareInstaller
        ;;
    esac

}

serviceInstaller() {
    helper --serviceInstaller
}

mainInstall() {
    helper --mainInstall
    read -p " what do you say < : " u
    case "$u" in
    1) softwareInstaller ;;
    2) serviceInstaller ;;
    r) main ;;
    x) exit_tasks ;;
    *) echo "abort, <$u>"
       mainInstall ;;
    esac
}


main() {
    helper --main
    read -p " what do you say < : " u
    case "$u" in
        1 | --[i]* ) mainInstall ;;
        2 | --[u]* ) mainUninstall ;;
        x) exit_tasks ;;
        *)  echo ""
            echo "<$u>.Choose an option: 1/2/3 "
            echo "visit https://minlaxz.web.app/init.html for detail."
            echo ""
            main ;;
        esac
}

helper(){
    case $1 in 
    --main)
        echo ""
        echo -e "\e[1;31m--Welcome to lxz installer--\e[0m"
        echo ""
        echo "1)install."
        echo "2)uninstall."
        echo "x)Adios, clean everything."
        ;;
    --mainInstall)
        echo ""
        echo "1)software."
        echo "2)service."
        echo "r)return Main."
        echo "x)exit."
        ;;
    --mainVersionChecker)
        echo ""
        echo "1)check nvidia-driver."
        echo "2)check cuda version."
        echo "3)check cudnn version."
        echo "a)check all versions in wild mode."
    ;;
    --serviceInstaller)
        echo "building..."
        ;;
    --softwareInstaller)
        echo ""
        echo "--installation options--"
        echo ""
        echo "1) > ::general dependencies."
        echo "2) > ::setup lax Desktop Enviroment. (like extensions)"
        echo "3) > ::setup Machine Learning Enviroment (cudnn cuda nvidia) would take some time."
        echo "r) > ::return Main."
        echo "b) > ::step back. Main Installer"
        echo "x) > ::exit."
        echo ""
        ;;
    esac
}
main