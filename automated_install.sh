#!/bin/bash

# Preconfigured variables

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
sudo cp /configurations/vsftpd.conf /etc/vsftpd.conf
echo $USER | sudo tee -a /etc/vsftpd.chroot_list
sudo systemctl restart vsftpd

echo "========== Please client-secrets file to AiVA-96-google-assistant-setup folder on Dragon Board 410c using ftp client ==========="
echo "********** You should rename client_secret_XXX.json to client_secret.json **********"
echo "========== and then input 'Yes'"
while [[ -z $UploadClientSecret ]] ; do
    echo "Did you upload client-secrets ?"
    read UploadClientSecret
done

echo "--------------------------------------"
echo "$UploadClientSecret,,"

if [ "$UploadClientSecret,," == "no" ]; then
    echo "You should upload client_secret.json. try again."
    exit 0;
fi

echo "========== Upgrade setuptools and oauthlib =========="
python3 -m venv env
env/bin/python -m pip install --upgrade pip setuptools
source env/bin/activate
python -m pip install --upgrade google-auth-oauthlib[tool]

echo "========== Progress oAuth =========="
google-oauthlib-tool --client-secrets $ClientSecret --scope https://www.googleapis.com/auth/assistant-sdk-prototype --save --headless

echo "========== Install gRPC and download Google Assistant SDK =========="
python -m pip install grpcio grpcio-tools
python -m pip install --upgrade google-assistant-sdk[samples]

echo "========== Regist device model =========="
googlesamples-assistant-devicetool --project-id lofty-ivy-192309 register-model --manufacturer "Assistant SDK developer" --product-name "Assistant SDK light" --type LIGHT --model roy-model
googlesamples-assistant-devicetool --project-id lofty-ivy-192309 list --model
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
python -m pushtotalk --device-model-id roy-model --project-id lofty-ivy-192309
