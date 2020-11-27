#!/bin/zsh

################################################################################
#              A quick script to setup c3270 and Xcode if needed.              #
#                    by Clayton Slaughter and William Young                    #
#                       clayton.thomas.slaughter@ibm.com                       #
#                             william.young@ibm.com                            #
################################################################################

# Make sure script is run as root
if [[ $UID -ne 0 ]]; then
    echo "This script must be run as root. Please run:\nsudo $0"
    exit 1
fi

# Set a bunch of variables
macver=$(/usr/bin/sw_vers -productVersion)
xcode_fooler=/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress


# Define the xcode install function
install_xcode () {
    touch $xcode_fooler
    install_candidate=$(softwareupdate -l | grep -B 1 -E 'Command Line Tools' | awk -F'*' '/^ *\*/ {    print }' | sed -e 's/Label: //' -e 's/^ *Label: //' -e 's/^ *//' -e 's/^* //' | sort -V | tail -n1)
    if [[ ! -z $install_candidate ]]; then
        softwareupdate -i $install_candidate
    fi
    rm $xcode_fooler
    if [[ ${macver:3} -gt 13 ]]; then
        if [[ ! -f /Library/Developer/CommandLineTools/usr/bin/git ]]; then 
            echo "Xcode tools could not be installed automatically";
            echo "please run 'xcode-select --install' manually to install the Xcode Command Line Tools, then rerun this script.";
            exit 100
        fi
    elif [[ ${macver:3} -gt 7 ]]; then
        if [[ ! -f /Library/Developer/CommandLineTools/usr/bin/git ]] || [[ ! -f /usr/include/iconv.h ]]; then
            echo "Xcode tools could not be installed automatically";
            echo "Please run 'xcode-select --install' manually to install the Xcode Command Line Tools, then rerun this script.";
            exit 100
        fi
    fi
}

# Actual script starts here.

echo "Checking for Xcode..."
# Get Xcode if needed
if [[ ${macver:3} -gt 13 ]]; then
    if [[ ! -f /Library/Developer/CommandLineTools/usr/bin/git ]]; then 
        install_xcode
    fi
elif [[ ${macver:3} -gt 7 ]]; then
    if [[ ! -f /Library/Developer/CommandLineTools/usr/bin/git ]] || [[ ! -f /usr/include/iconv.h ]]; then
        install_xcode
    fi
else
    # Tell them their Mac is too dang old.
    echo "Sorry, but your version of OS X is unsupported."
    exit 27
fi
echo "Xcode is installed."

# Make temp work dir
wrkdir=$(mktemp -d)
cd $wrkdir
echo "Building in $PWD"
# Grab the source code
curl http://x3270.bgp.nu/download/03.06/suite3270-3.6ga8-src.tgz | tar -x
cd suite3270-3.6

# Build and install
./configure --enable-c3270
if [[ $? -eq 0 ]]; then
    make
    if [[ $? -eq 0 ]]; then
        make install
    else
        echo "Make failed. Contact your system administrator."
    fi
else
    echo "The configuration of c3270 failed. Contact your system administrator."
fi

if [[ $1 == "noclean" ]]; then
    echo "Not cleaning work directory"
    echo $wrkdir
    exit 0
fi
rm -rf $wrkdir