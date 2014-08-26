#!/bin/bash

echo -ne "Detected '$(lsb_release -sd)'\n"

function install_gem {
    if ! gem spec $1 > /dev/null 2>&1; then
        sudo gem install $1
    else
        echo -e "\e[32mGem $1 already installed\e[0m"
    fi
}

# --------------------------------------------------------
# INSTALLATION

# - Install Puppet (with ruby-dev for librarian)
PUPPET_INSTALLED=$(dpkg-query -W --showformat='${Status}\n' puppet | grep "install ok installed")
if [ "" == "$PUPPET_INSTALLED" ]; then
    sudo apt-get -y install wget
    wget http://apt.puppetlabs.com/puppetlabs-release-$(lsb_release -sc).deb
    sudo dpkg -i puppetlabs-release-$(lsb_release -sc).deb
    sudo apt-get update
    sudo apt-get -y install puppet ruby1.9.1-dev graphviz
    rm puppetlabs-release*
else
    echo -e "\e[32mPuppet already installed\e[0m"
fi

# - Install Puppet Librarian and Lint
install_gem librarian-puppet
install_gem puppet-lint
