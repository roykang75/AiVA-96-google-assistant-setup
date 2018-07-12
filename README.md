AiVA-96 for Google Assistant SDK on Dragon Board 410c 
---
The AiVA-96 for Google Assistant provides far-field voice capture using the XMOS XVF3000 voice processor.

Combined with a Dragon Boarad 410c running the Google Assistant Software Development Kit (SDK), this kit allows you to quickly prototype and evaluate talking with Google Assistant.

To find out more, visit: https://wiziot home page  
and: https://developers.google.com/assistant/sdk/guides/library/python/?hl=en

This repository provides a simple-to-use automated script to install the Google Assistant SDK on a Dragon Board 410c and configure the Dragon Board 410c to use the AiVA-96 for Google Assistant for audio.

Prerequisites
---

You will need:

- AiVA-96 Board
- Dragon Board 410c
- Dragon Board 410c power supply
- MicroSD card (min. 16GB)
- Monitor with HDMI input
- HDMI cable
- Fast-Ethernet connection with internet connectivity  

You will also need an Google account: https://developers.google.com/assistant/sdk/?hl=en

Hardware setup
---
Setup your hardware by following the Hardware Setup at: https://wiziot home page

Google Assistant SDK installation and Dragon Board 410c audio setup
---
Full instructions to install the Google Assistant SDK on to a Dragon Board 410c and configure the audio to use the AiVA-96 are detailed in the Getting Started Guide available from: https://wiziot home page.

Brief instructions and additional notes are below:

1. Install Debian (Stretch) on the Dragon Board 410c.  
   You shoud use [Debian 17.09](http://releases.linaro.org/96boards/dragonboard410c/linaro/debian/17.09/dragonboard410c_sdcard_install_debian-283.zip)

2. Open a terminal on the Dragon Board 410c and clone this repository
    ```
    cd ~; git clone https://github.com/roykang75/AiVA-96-google-assistant-setup.git
    ```

3. Create a new Google Assistant Project and Device by following
    + Configure a Developer Project and Account Settings
    https://developers.google.com/assistant/sdk/guides/library/python/embed/config-dev-project-and-account?hl=en

    + Register the Device Model  
    https://developers.google.com/assistant/sdk/guides/library/python/embed/register-device?hl=en  
    (Download credentials file to Local PC. (Don't transfer it to device, yet))

4. Run the installation script
    ```
    cd AiVA-96-google-assistant-setup/
    bash automated_install.sh
    ```

See [Project ID](https://github.com/roykang75/AiVA-96-google-assistant-setup/blob/master/ProjectID.md)  
See [Device Model ID](https://github.com/roykang75/AiVA-96-google-assistant-setup/blob/master/ModelID.md)
