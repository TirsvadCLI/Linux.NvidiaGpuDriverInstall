[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<br />
<div align="center">
    <a href="https://github.com/TirsvadCLI/Linux.NvidiaGpuDriverInstall">
        <img src="logo/logo.png" alt="Logo" width="80" height="80">
    </a>
</div>

# Linux Nvidia GPU Driver Installation

This script automates the process of installing NVIDIA drivers on a Debian-based system. It performs necessary system checks, installs required dependencies, handles UEFI keys, and manages temporary systemd services for a smooth installation.

Follow the guide and it's instructions to download and install the NVIDIA driver, including support for systems with Secure Boot (UEFI). If you have an older NVIDIA card, you can switch to a compatible driver by modifying the value in the script at the top.

## Prerequisites

Ensure that `cURL` is installed on your system. If it's not installed, you can do so using the following command:

```bash
apt -y install curl
```

## Install

### Configuration (Optional)

You can make changes in the config.sh file

- DRIVERLINK is the path of download. It may need to change if you have a older nvidia card.
- PASSWORD is the UEFI password. Default is set to Secret1234 and used first time the bios is getting the signing key.

### Installation Steps

Login as root.  
Download the script.

```bash
curl -L https://github.com/TirsvadCLI/Linux.NvidiaGpuDriverInstall/tarball/master | tar xz -C /root/ --strip-components=2
cd /root/NvidiaGpuDriverInstall
bash install.sh
```

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

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/TirsvadCLI/Linux.NvidiaGpuDriverInstall?style=for-the-badge
[contributors-url]: https://github.com/TirsvadCLI/Linux.NvidiaGpuDriverInstall/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/TirsvadCLI/Linux.NvidiaGpuDriverInstall?style=for-the-badge
[forks-url]: https://github.com/TirsvadCLI/Linux.NvidiaGpuDriverInstall/network/members
[stars-shield]: https://img.shields.io/github/stars/TirsvadCLI/Linux.NvidiaGpuDriverInstall?style=for-the-badge
[stars-url]: https://github.com/TirsvadCLI/Linux.NvidiaGpuDriverInstall/stargazers
[issues-shield]: https://img.shields.io/github/issues/TirsvadCLI/Linux.NvidiaGpuDriverInstall?style=for-the-badge
[issues-url]: https://github.com/TirsvadCLI/Linux.NvidiaGpuDriverInstall/issues
[license-shield]: https://img.shields.io/github/license/TirsvadCLI/Linux.NvidiaGpuDriverInstall?style=for-the-badge
[license-url]: https://github.com/TirsvadCLI/Linux.NvidiaGpuDriverInstall/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/jens-tirsvad-nielsen-13b795b9/
