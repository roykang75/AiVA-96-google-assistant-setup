#!/bin/bash

# Preconfigured variables
credentials="credentials.json"
Origin=$(pwd)
credentials_Loc=$Origin/$credentials


while [[ -z $ProjectID ]] ; do
    echo "project-id : "
    read ProjectID
done

while [[ -z $DeviceModelID ]] ; do
    echo "device-model-id : "
    read DeviceModelID
done

echo ""
echo ""
echo "==============================="
echo "*******************************"
echo " *** STARTING INSTALLATION ***"
echo "  ** this may take a while **"
echo "   *************************"
echo "   ========================="
echo ""
echo ""

#-------------------------------------------------------
# add library path
#-------------------------------------------------------
#echo "export LD_LIBRARY_PATH=/usr/local/lib" | tee -a ~/.bashrc
#echo "export VLC_PLUGIN_PATH=/usr/local/lib/pkgconfig" | tee -a ~/.bashrc
#source ~/.bashrc

#-------------------------------------------------------
# Install dependencies
#-------------------------------------------------------
echo "========== Update Aptitude ==========="
sudo apt-get update
sudo apt-get upgrade -y

get_platform() {
  uname_str=`uname -a`

  if [[ "$uname_str" ==  "Linux raspberrypi"* ]]
  then
    result="rpi"
  elif [[ "$uname_str" ==  "MINGW64"* ]]
  then
    result="mingw64"
  elif [[ "$uname_str" == "Linux linaro-alip"* ]]
  then 
    result="db410c"
  else
    result=""
  fi
}

get_platform
PLATFORM=$result

if [ "$PLATFORM" == "rpi" ]
then
  source rpi.sh
#elif [ "$PLATFORM" == "mingw64" ]
#then
#  source mingw.sh
elif [ "$PLATFORM" == "db410c" ]
then
  source db410c.sh
else
  echo "The installation script doesn't support current system. (System: $(uname -a))"
  exit 1
fi
