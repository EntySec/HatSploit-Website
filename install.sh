#!/bin/bash

#
# MIT License
#
# Copyright (c) 2020-2021 EntySec
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

I="\033[1;77m[i] \033[0m"
G="\033[1;34m[*] \033[0m"
S="\033[1;32m[+] \033[0m"
E="\033[1;31m[-] \033[0m"
P="\033[1;77m[>] \033[0m"

while [[ $(sudo -n id -u 2>&1) != 0 ]]; do
    {
        sudo -v -p "$(echo -e -n $P)Password for $(whoami): " 
    } &> /dev/null
done

echo -e $G"Installing HatSploit Framework..."

if [[ $(uname -s) == "Darwin" && $(uname -m) == "x86_64" || $(uname -m) == "arm64" ]]; then
    if [[ -z $(command -v brew) ]]; then
        if [[ $(uname -m) == "arm64" ]]; then
            arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        fi
    fi
    if [[ $(uname -m) == "arm64" ]]; then
        {
            arch -x86_64 brew install git python3 openssl
            arch -x86_64 brew link python3
        } &> /dev/null
    else
        {
            brew install git python3 openssl
            brew link python3
        } &> /dev/null
    fi
    {
        sudo python3 -m ensurepip
    } &> /dev/null
elif [[ $(uname -s) == "Linux" ]]; then
    if [[ ! -z $(command -v apt-get) ]]; then
        {
            sudo apt-get update
            sudo apt-get -y install git python3 python3-pip openssl
        } &> /dev/null
    elif [[ ! -z $(command -v pkg) ]]; then
        {
            sudo pkg update
            sudo pkg -y install git python openssl
        } &> /dev/null
    elif [[ ! -z $(command -v apk) ]]; then
        {
            sudo apk update
            sudo apk add git python3 py3-pip openssl
        } &> /dev/null
    elif [[ ! -z $(command -v pacman) ]]; then
        {
            sudo pacman -Sy
            sudo pacman -S --noconfirm git python3 python3-pip openssl
        } &> /dev/null
    elif [[ ! -z $(command -v zypper) ]]; then
        {
            sudo zypper refresh
            sudo zypper install -y git python3 python3-pip openssl
        } &> /dev/null
    elif [[ ! -z $(command -v eopkg) ]]; then
        {
            sudo eopkg update-repo
            sudo eopkg -y install git python3 python3-pip openssl
        } &> /dev/null
    elif [[ ! -z $(command -v xbps-install) ]]; then
        {
            sudo xbps-install -S
            sudo xbps-install -y git python3 python3-pip openssl
        } &> /dev/null
    elif [[ ! -z $(command -v yum) ]]; then
        {
            sudo yum -y install git python3 python3-pip openssl
        } &> /dev/null
    elif [[ ! -z $(command -v dnf) ]]; then
        {
            sudo dnf -y install git python3 python3-pip openssl
        } &> /dev/null
    else
        echo -e $E"Your system is not supported!"
        exit 1
    fi
else
    echo -e $E"Your system is not supported!"
    exit 1
fi

{
    sudo python3 -m pip install setuptools
    sudo python3 -m pip install -r deps/core_dependencies.txt
    sudo python3 -m pip install -r deps/plugins_dependencies.txt
    sudo python3 -m pip install -r deps/modules_dependencies.txt
} &> /dev/null

if [[ ! -d /opt ]]; then
    {
        sudo mkdir /opt
    } &> /dev/null
fi

{
    sudo git clone https://github.com/EntySec/HatSploit.git /opt/hsf
} &> /dev/null

if [[ -d /opt/hsf ]]; then
    cd /opt/hsf
else
    echo -e $E"Installation failed!"
    exit 1
fi

if [[ ! -d /usr/local/bin ]]; then
    {
        sudo mkdir /usr/local/bin
    } &> /dev/null
fi

{
    sudo cp bin/hsf /usr/local/bin
    sudo chmod +x /usr/local/bin/hsf
    sudo cp bin/hsf /data/data/com.termux/files/usr/bin
    sudo chmod +x /data/data/com.termux/files/usr/bin/hsf
} &> /dev/null

echo -e $S"Successfully installed!"
exit 0
