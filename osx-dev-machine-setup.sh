#!/bin/bash -eux

# Install Xcode and Xcode Command Line Tools
xcode-select --install

# Install Brew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/binary
brew update

# Install git
brew install git
echo -n "Enter your full name for git and press [ENTER]: "
read fullname
echo -n "Enter your email address for git and press [ENTER]: "
read emailaddress
git config --global user.name "$fullname"
git config --global user.email "$emailaddress"

# Install dsh
brew install dsh
mkdir -p ~/.dsh/groups

# Install awscli
sudo pip install awscli
mkdir -p ~/.aws
echo "[default]" >> ~/.aws/config
echo "region=us-west-1" >> ~/.aws/config
echo "output=json" >> ~/.aws/config

# Install Virtualbox
cd ~/Downloads/
curl -L -O http://download.virtualbox.org/virtualbox/4.3.12/VirtualBox-4.3.12-93733-OSX.dmg
hdiutil attach VirtualBox-*.dmg
sudo installer -pkg /Volumes/VirtualBox/VirtualBox.pkg -target /
hdiutil detach /Volumes/VirtualBox

# Install Vagrant
curl -L -O https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3.dmg
hdiutil attach vagrant_*.dmg
sudo installer -pkg /Volumes/Vagrant/Vagrant.pkg -target /
hdiutil detach /Volumes/Vagrant

# Install Packer
brew install packer

# Setup local srv folder
if [[ ! -f /srv ]]; then
	sudo mkdir /srv
fi
sudo chown -R `eval whoami` /srv
cd /srv

# Create id_rsa key if needed
if [[ ! -f $HOME/.ssh/id_rsa ]]; then
	ssh-keygen -t rsa -C "$emailaddress"
	chmod 600 $HOME/.ssh/id_rsa
fi

cat ~/.ssh/id_rsa.pub | mail -s "$HOSTNAME `whoami` $emailaddress public key" mcupples@cloudspace.com
