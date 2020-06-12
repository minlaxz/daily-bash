#!/bin/sh
# this is coded by minlaxz `github.com/minlaxz`
# you can change whatever you want to!
# cuDNN CUDA Nvidia -> https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html#installlinux-tar
set -e


this_prefix=/home/$USER/.local/share/laxz/tmp

general_install() {
    echo "installing general dependencies."
    sudo apt install build-essentials net-tools cmake gcc g++ python3-dev git vim curl wget
}
zsh_shell_install() {
    sudo apt install zsh curl
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i "s/plugins=[^ ]*/plugins=(git zsh-autosuggestions)/" /home/$USER/.zshrc
}
miniconda_install() {
    echo "Miniconda Installation."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod a+x ./Miniconda3-latest-Linux-x86_64.sh
    sh ./Miniconda3-latest-Linux-x86_64.sh
}

cuda_install(){
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
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.laxz_ml_profile
    echo "export PATH=/usr/local/cuda-11.0/bin${PATH:+:${PATH}}" >> ~/.laxz_ml_profile
}
cudnn_install(){
    echo "cudnn installation."
    wget https://black-moon-3dba.gdindex-laxz.workers.dev/cuDNNv7.6.4Sep2719CUDA10.1/cudnn-10.1-linux-x64-v7.6.4.38.tgz
    tar -xzvf cudnn-10.1-linux-x64-v7.6.4.38.tgz
    sudo mv cuda/include/cudnn*.h /usr/local/cuda/include
    sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
    sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
    sudo rm -rf ./cuda
}
activate_for_ml(){
    echo "cudnn, cuda will be only ava in this session"
    source /home/$USER/.laxz_ml_profile
}
make_ml_env(){
    cuda_install
    cudnn_install
}
workspace_fix(){
    #detail in `laxz-dilemma`
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
}
opencv_install() {
    echo "installing required build dependencies."
    sudo apt install cmake gcc g++ git
    echo "to support python3."
    sudo python3-dev python3-numpy
    echo "GTK support for GUI features, Camera support (v4l), Media Support (ffmpeg, gstreamer) etc."
    sudo apt install libavcodec-dev libavformat-dev libswscale-dev
    sudo apt install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
    echo "to support gtk3"
    sudo apt install libgtk-3-dev
    echo "optional Dependencies"
    sudo apt install libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev

    echo "Downaloading openCV..."
    git clone https://github.com/opencv/opencv.git
    cd opencv
    mkdir build
    cd build
    cmake ../
    make -j2
    sudo make install
    echo "opencv version: "
    python3 -c "import cv2 as cv; print(cv.__version__)"
    echo "you can install opencv in conda env _python_."
    echo "conda create --name mlearn python=3 && conda activate mlearn && pip install opencv-python"
}
test_install() {
    sudo apt install test
}

laxz_install(){
    echo "laxz installer."
    laxz_prefix=/home/$USER/.local/share/.laxz
    mkdir -p laxz_prefix
    git clone https://github.com:minlaxz/daily-bash.git $laxz_prefix
    chmod 700 $laxz_prefix/*
    echo "laxz is installed."
}
installer() {
    option=$1
    case "$option" in
    general)
        echo "installing general dependencies..."
        ;;
    opencv)
        echo "installing opencv..."
        ;;
    test)
        echo "testing..."
        test_install
        ;;
    *)
        echo "[handler]: abort."
        echo "[handler]: visit https://minlaxz.web.app/init.html for detail."
        ;;
    esac
}
main() {
    echo "--Welcome to laxz--"
    PS3="install options: "
    options=("test" "opencv" "Adios")
    select opt in "${options[@]}"; do
        case "$opt" in
        "test")
            installer test
            break
            ;;
        "opencv")
            echo "#TODO"
            break
            ;;
        "Adios" | "q")
            echo "you chose choice $REPLY which is $opt !" '("Exit")'
            rm -rf $this_prefix
            break
            ;;
        *)
            echo "invalid option $REPLY"
            ;;
        esac
    done
}
main
