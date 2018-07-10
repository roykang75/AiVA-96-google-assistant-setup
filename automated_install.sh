#!/bin/bash

# Preconfigured variables
credentials="credentials.json"
Origin=$(pwd)
credentials_Loc=$Origin/$credentials

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

echo "========== Installing python3 and Libraries ==========="
sudo apt-get install -y nano vim vsftpd
sudo apt-get install -y python3 python3-dev python-dev python3-venv python-serial
sudo apt-get upgrade python3
sudo apt-get install -y autoconf build-essential libtool libtool-bin pkg-config automake libpcre3-dev mpg123
sudo apt-get install -y portaudio19-dev libffi-dev libssl-dev

echo "========== Setup vsftpd ==========="
sudo cp ./configurations/vsftpd.conf /etc/vsftpd.conf
echo $USER | sudo tee -a /etc/vsftpd.chroot_list >> /dev/null
sudo systemctl restart vsftpd

echo "========== Please credentials.json file to AiVA-96-google-assistant-setup folder on Dragon Board 410c using ftp client ==========="
echo "========== and then input 'Yes'"
while [[ -z $IsUploadCredentials ]] ; do
    echo "Did you upload credentials.json ?"
    read IsUploadCredentials
done

if [ ${IsUploadCredentials,,} == "no" ]; then
    echo "You should upload credentials.json. try again."
    trap - ERR
    exit -1
fi

if [ -f $credentials_Loc ]; then
    echo "credentials.json found."
else
    echo "credentials.json doesn't found."
    trap - ERR
    exit -1 
fi

echo "========== Upgrade setuptools and oauthlib =========="
python3 -m venv env
env/bin/python -m pip install --upgrade pip setuptools
source env/bin/activate
python -m pip install --upgrade google-auth-oauthlib[tool]

echo "========== Progress oAuth =========="
google-oauthlib-tool --client-secrets client_secret.json --scope https://www.googleapis.com/auth/assistant-sdk-prototype --save --headless

echo "========== Install gRPC and download Google Assistant SDK =========="
python -m pip install grpcio grpcio-tools
python -m pip install --upgrade google-assistant-sdk[samples]

echo "========== Regist device model =========="
#googlesamples-assistant-devicetool --project-id aiva-96-dbb52 register-model --manufacturer "WizIoT" --product-name "AiVA-96" --type LIGHT --model "AiVA-96-Speaker" 
googlesamples-assistant-devicetool --project-id aiva-96-dbb52 list --model
git clone https://github.com/googlesamples/assistant-sdk-python
cp -r assistant-sdk-python/google-assistant-sdk/googlesamples/assistant/grpc new-project

chmod +x *.sh
cp pushtotalk.py ./new-project/

echo ""
echo '============================='
echo '*****************************'
echo '========= Finished =========='
echo '*****************************'
echo '============================='
echo ""

cd new-project
echo "========== Run Google Assistant =========="
python -m pushtotalk --project-id aiva-96-dbb52 --device-model-id aiva-96-dbb52-aiva-96-kw8qpo 
