#!/bin/bash

echo "========== Installing python3 and Libraries ==========="
sudo apt-get install -y vim vsftpd pulseaudio
sudo apt-get install -y python3 python3-dev python3-venv
python3 -m venv env
env/bin/python -m pip install --upgrade pip setuptools wheel
source env/bin/activate

echo "========== Install the package's system dependencies =========="
sudo apt-get install -y portaudio19-dev libffi-dev libssl-dev libmpg123-dev

echo "========== Setup vsftpd ==========="
sudo cp ./configurations/vsftpd.conf /etc/vsftpd.conf
echo $USER | sudo tee -a /etc/vsftpd.chroot_list >> /dev/null
sudo systemctl restart vsftpd

echo "========== Please credentials.json file to AiVA-96-google-assistant-setup folder on Raspberry Pi using ftp client ==========="
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

echo "========== Upgrade Google Assistant SDK and oauthlib =========="
python -m pip install --upgrade google-assistant-library
python -m pip install --upgrade google-assistant-sdk[samples]
python -m pip install --upgrade google-auth-oauthlib[tool]

echo "========== Progress oAuth =========="
#google-oauthlib-tool --client-secrets credentials.json --scope https://www.googleapis.com/auth/assistant-sdk-prototype --save --headless
google-oauthlib-tool --scope https://www.googleapis.com/auth/assistant-sdk-prototype --scope https://www.googleapis.com/auth/gcm --save --headless --client-secrets /home/pi/credentials.json

#echo "========== Regist device model =========="
#googlesamples-assistant-devicetool --project-id aiva-96-dbb52 register-model --manufacturer "WizIoT" --product-name "AiVA-96" --type LIGHT --model "AiVA-96-Speaker" 
#googlesamples-assistant-devicetool --project-id $ProjectID list --model

echo "#!/bin/bash" | tee -a ./run_google_assistant_en.sh > /dev/null
echo "python3 -m venv env" | tee -a ./run_google_assistant_en.sh > /dev/null
echo "source env/bin/activate" | tee -a ./run_google_assistant_en.sh > /dev/null
echo "googlesamples-assistant-hotword --project_id  $ProjectID --device-model-id $DeviceModelID" | tee -a ./run_google_assistant_en.sh > /dev/null

chmod +x ./run_google_assistant_en.sh

echo ""
echo '==========================================================================='
echo '***************************************************************************'
echo '=============================== Finished =================================='
echo 'Please run run_google_assistant_en.sh'
echo 'If need other language, change --lang option on run_google_assistant_en.sh'
echo '***************************************************************************'
echo '==========================================================================='
echo ""
