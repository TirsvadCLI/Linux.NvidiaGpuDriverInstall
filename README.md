# Linux.NvidiaGpuDriverInstall
This will download nvidia driver and install. Even with secure boot (UEFI).  
If you have a older nvidia card you may change to a older driver by changing value in the top of the script.  

## Conventions

\# – requires given linux commands to be executed with root privileges either.  
directly as a root user or by use of sudo command.  
$ – requires given linux commands to be executed as a regular non-privileged user

## Prepare

You need to have cURL installed.

    # apt -y install curl

## Install

Login as root.  
Download the script.  

    # curl -L https://github.com/Tirsvad/Linux.NvidiaGpuDriverInstall/tarball/master | tar xz -C /root/ --strip-components 2

Optional change the driver to the one is fitting your display adapter.  
Optional the password of signing key can be edited in the config.sh file.  
PASSWORD is set to Secret1234 and used first time the bios is getting the signing key.

    # cd ~/NvidiaAutoInstallForLinux
    # bash install.sh

It will reboot 2 times in non graphical login.  
ONLY UEFI: Bios may ask about new key that we created for signing the driver. Load the new key into bios so nvidiadriver can be acceptet.  
When finish it will reboot into graphical login again.
