#!/bin/sh
# this is coded by minlaxz `github.com/minlaxz`
# you may do with this what the fuck you want to.
# nth to say.
set -e

general_install() {
    echo "installing general dependencies."
    apt install build-essentials net-tools cmake gcc g++ python3-dev git vim curl
}
shell_install() {
    sudo apt install zsh curl
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}
miniconda_install() {
    echo "Miniconda Installation."

}
opencv_install() {
    echo "installing required build dependencies."
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
}
test_install(){
    sudo apt install tree
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
    flag=$1
    option=$2
    echo -e "\a"
    echo "--Welcome to laxz--"
    case "$flag" in
    install)
        installer $option
        ;;
    *)
        echo "[main]: Not a valid flag: $flag"
        ;;
    esac
}

main "$@"

#https://raw.githubusercontent.com/minlaxz/daily-bash/master/laxz_autoconfig.sh
