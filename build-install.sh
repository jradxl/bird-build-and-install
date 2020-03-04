#!/usr/bin/env bash

set -eu

##TODO: Ensure same User as in envvars file
USER=bird
HOME="/var/lib/$USER"
BIRD_SOURCE=bird-2.0.7.tar.gz
BIRD_SOURCE_DIR="${BIRD_SOURCE%.tar.gz}"
BIRD_URL="ftp://bird.network.cz/pub/bird/$BIRD_SOURCE"

sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y flex
sudo apt-get install -y bison
sudo apt-get install -y libreadline-dev
sudo apt-get install -y libncurses-dev

#Download if not exist
if [ ! -f $BIRD_SOURCE ]; then
    echo "Downloading Bird Source..."
    wget $BIRD_URL
    if [ -d $BIRD_SOURCE_DIR ]; then
        echo "Removing current build..."
        rm -rf $BIRD_SOURCE_DIR
    fi
fi

if [ ! -f $BIRD_SOURCE_DIR ]; then
        echo "Unpacking..."
        tar xf $BIRD_SOURCE
fi

cd $BIRD_SOURCE_DIR
echo "CONFIGURING..."
./configure
echo "BUILDING..."
make
echo "INSTALLING..."
sudo make install

cd ..

echo "CREATING USER and HOME DIR..."

if [ ! -d $HOME ]; then
    echo "Creating User $USER home directory"
    sudo mkdir --parents $HOME
fi

id -u $USER &>/dev/null || sudo useradd --system --user-group --home-dir $HOME --shell /usr/sbin/nologin $USER

if [ ! -d "/usr/local/etc/bird" ]; then
    echo "Creating directory"
    sudo mkdir --parents "/usr/local/etc/bird/"
fi

sudo mv /usr/local/etc/bird.conf /usr/local/etc/bird/bird.conf-sample
sudo cp ./bird.conf* /usr/local/etc/bird/
sudo chown $USER:$USER /usr/local/etc/bird/bird.conf*
sudo cp ./envvars /usr/local/etc/bird/
sudo cp ./prepare-environment /usr/local/etc/bird/
sudo cp ./bird.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable bird.service
sudo systemctl restart bird.service
sudo systemctl status bird.service

echo "DONE"
exit 0

