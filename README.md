# Linux Nvidia GPU Driver Installation

This script automates the process of installing NVIDIA drivers on a Debian-based system. It performs necessary system checks, installs required dependencies, handles UEFI keys, and manages temporary systemd services for a smooth installation.

Follow the guide and it's instructions to download and install the NVIDIA driver, including support for systems with Secure Boot (UEFI). If you have an older NVIDIA card, you can switch to a compatible driver by modifying the value in the script at the top. 


## Conventions

- `#` – Indicates that the command requires root privileges. You can either run the command as the root user or prefix it with `sudo`.
- `$` – Indicates that the command should be executed as a regular non-privileged user.

## Prerequisites

Ensure that `cURL` is installed on your system. If it's not installed, you can do so using the following command:

```bash
# apt -y install curl
```

## Install

### Configuration (Optional)
You can make changes in the config.sh file

- DRIVERLINK is the path of download. It may need to change if you have a older nvidia card.
- PASSWORD is the UEFI password. Default is set to Secret1234 and used first time the bios is getting the signing key.

### Installation Steps
Login as root.  
Download the script.  

    # curl -L https://github.com/TirsvadCLI/Linux.NvidiaGpuDriverInstall/tarball/master | tar xz -C /root/ --strip-components=2

    # cd cd /root/NvidiaGpuDriverInstall
    # bash install.sh

### Post-Installation

- The system will reboot twice during the installation process, entering a non-graphical login interface.
- **For UEFI systems, the BIOS may prompt you to load the new signing key that was created during the installation. Ensure to load this key so that the NVIDIA driver can be accepted.**

Once the installation is complete, the system will reboot and present you with a graphical login interface.

## Package Installation
- Add Non-Free to Repository:
    apt-add-repository non-free: Adds the non-free repository necessary for NVIDIA drivers.
- Install Dependencies:
    - mokutil
    - openssl
    - linux-headers
    - build-essential
    - pkg-config
    - libglvnd-dev

## Troubleshooting

See logfiles
- runonetime-nvidia-installer-step-01.log
- runonetime-nvidia-installer-step-02.log
