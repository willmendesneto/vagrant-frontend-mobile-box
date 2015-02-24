#!/usr/bin/env bash

# Configuration Variables
ANDROID_SDK_FILENAME=android-sdk_r23.0.2-linux.tgz
ANDROID_SDK=http://dl.google.com/android/$ANDROID_SDK_FILENAME

# This boolean is used for load bash or zsh in your CLI environment
# By default is loaded .bashrc, if you would like to use .zsh + oh-my-zsh in your CLI
# modify the value for true
INCLUDE_ZSH=false

#sudo apt-get install python-software-properties
#sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update -y
sudo apt-get install -y curl git git-core
sudo apt-get install -y openjdk-7-jdk ant expect
#ADB Not Responding
sudo apt-get install -y lib32z1 lib32z1-dev lib32stdc++6
#apt-get install ruby-full
sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config


# Install pt_BR
sudo locale-gen pt_BR.UTF-8

curl -O $ANDROID_SDK
tar -xzvf $ANDROID_SDK_FILENAME
sudo chown -R vagrant android-sdk-linux/
sudo rm -rf $ANDROID_SDK_FILENAME

# Install NVM
cd /home/vagrant
wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh
export NVM_DIR="/home/vagrant/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Install NodeJS
nvm install 0.10.33
nvm use 0.10.33
nvm alias default 0.10.33

# Update NPM
# npm update -g npm@latest
npm update -g npm@2.2.0

# Install Node Packages
npm install -g cordova
npm install -g ionic
npm install -g yo
npm install -g bower
npm install -g grunt-cli
npm install -g jshint
npm install -g protractor
npm install -g gulp
npm install -g karma

# Install Yeoman Generator


# Add .function and .aliases files in box
curl -L http://goo.gl/2e3iWT > .functions
curl -L http://goo.gl/ii1v3n > .aliases

# ...zsh/bash verification ...

CLI_LOAD_FILE=~/.bashrc
if [ "$INCLUDE_ZSH" = true ] ; then
  # Zsh and Oh-My-Zsh installation
  CLI_LOAD_FILE=~/.zshrc
  sudo apt-get install -y zsh
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template $CLI_LOAD_FILE
  sudo chsh -s /bin/zsh vagrant
  zsh
fi

# Add new contents in .zshrc/.bashrc
echo "" >> $CLI_LOAD_FILE
echo "" >> $CLI_LOAD_FILE
echo " # Source global definitions" >> $CLI_LOAD_FILE
echo "if [ -f ~/.functions ]; then" >> $CLI_LOAD_FILE
echo "  . ~/.functions" >> $CLI_LOAD_FILE
echo "fi" >> $CLI_LOAD_FILE
echo "" >> $CLI_LOAD_FILE
echo " # Source global definitions" >> $CLI_LOAD_FILE
echo "if [ -f ~/.aliases ]; then" >> $CLI_LOAD_FILE
echo "  . ~/.aliases" >> $CLI_LOAD_FILE
echo "fi" >> $CLI_LOAD_FILE
echo "" >> $CLI_LOAD_FILE
echo "" >> $CLI_LOAD_FILE
echo "export NVM_DIR=\"\$HOME/.nvm\"" >> $CLI_LOAD_FILE
echo "#Add new values from variable environment" >> $CLI_LOAD_FILE
echo "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386/jre/bin/java" >> $CLI_LOAD_FILE
echo "ANDROID_HOME=~/android-sdk-linux" >> $CLI_LOAD_FILE
echo "export PATH=\$PATH:~/android-sdk-linux/tools:~/android-sdk-linux/platform-tools:\$NVM_DIR/bin" >> $CLI_LOAD_FILE
# This loads nvm
echo "[[ -s \"\$NVM_DIR/nvm.sh\" ]] && . \"\$NVM_DIR/nvm.sh\"" >> $CLI_LOAD_FILE

source $CLI_LOAD_FILE


# Installs RubyGems
sudo gem update --system #gets the latest version of the RubyGems installer
sudo gem install rubygems-update
sudo update_rubygems
sudo gem install sass
sudo apt-get install -y ruby-compass

expect -c '
set timeout -1   ;
spawn /home/vagrant/android-sdk-linux/tools/android update sdk -u --all --filter platform-tool,android-19,build-tools-19.1.0
expect {
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
}
'
# alias for adb
echo "alias adb=\"/home/vagrant/android-sdk-linux/platform-tools/adb\"" >> $CLI_LOAD_FILE
echo "alias vd=\"cd /vagrant_data\"" >> $CLI_LOAD_FILE

sudo /home/vagrant/android-sdk-linux/platform-tools/adb kill-server
sudo /home/vagrant/android-sdk-linux/platform-tools/adb start-server
sudo /home/vagrant/android-sdk-linux/platform-tools/adb devices
