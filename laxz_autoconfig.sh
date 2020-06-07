#!/bin/sh
general() {
    echo "installing general libraries."
    apt install build-essentials net-tools cmake gcc g++ python3-dev git vim curl
}
shell() {
    sudo apt install zsh curl
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}
miniconda() {
    echo "Miniconda Installation."

}
opencv() {
    echo "Required build dependencies."
    sudo apt install cmake gcc g++
    echo "to support python3."
    sudo python3-dev python3-numpy
    echo "GTK support for GUI features, Camera support (v4l), Media Support (ffmpeg, gstreamer) etc."
    sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev
    sudo apt-get install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
    echo "to support gtk3"
    sudo apt-get install libgtk-3-dev
    echo "Optional Dependencies"
    sudo apt-get install libpng-dev
    sudo apt-get install libjpeg-dev
    sudo apt-get install libopenexr-dev
    sudo apt-get install libtiff-dev
    sudo apt-get install libwebp-dev
    sudo apt install git
    echo "Downaloading openCV"
    git clone https://github.com/opencv/opencv.git
    cd opencv
    mkdir build
    cd build
    cmake ../
    make
    sudo make install
    echo "opencv version: " 
    python3 -c "import cv2 as cv; print(cv.__version__)"
    #import cv2 as cv
    #print(cv.__version__)
}

main(){
    flag=$1
    option=$2
    echo "--Welcome to laxz--"
    echo -e "\a"
    echo "flag: " $flag
    echo "option: " $option
}

main "$@"