#!/bin/bash
# @file
# @brief Script to automate the installation of NVIDIA drivers on a Debian-based system.
#
# This script checks for root privileges, installs necessary packages, 
# handles UEFI key generation, and manages subsequent installation steps 
# through temporary systemd services.

ROOT_DIR=$(dirname $(readlink -f $0))

# Include configuration file
. $ROOT_DIR/config.sh

# @brief Check if the script is being run as root.
# @exit This script must be run as root.
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit
fi

# Clean up if the script has been runned before
rm -f /root/runonetime-nvidia-installer-step-01.log
rm -f /root/runonetime-nvidia-installer-step-02.log
rm -f /usr/local/bin/runonetime-nvidia-installer-step-01.sh
rm -f /usr/local/bin/runonetime-nvidia-installer-step-02.sh
rm -f /etc/systemd/system/runonetime-nvidia-installer-step-01.service
rm -f /etc/systemd/system/runonetime-nvidia-installer-step-02.service

# @brief Install required packages non-interactively.
apt-add-repository non-free

# @brief Install required packages non-interactively.
DEBIAN_FRONTEND=noninteractive apt-get -qq update && apt-get -qq upgrade
DEBIAN_FRONTEND=noninteractive apt-get -qq install mokutil openssl
DEBIAN_FRONTEND=noninteractive apt-get -qq install linux-headers-$(uname -r) build-essential
DEBIAN_FRONTEND=noninteractive apt-get -qq install pkg-config
DEBIAN_FRONTEND=noninteractive apt-get -qq install libglvnd-dev

cd /root
FILENAME=$(basename "$DRIVERLINK")

# @brief Download the NVIDIA driver if it does not exist.
if [ ! -f /root/$FILENAME ]; then
	curl -LO $DRIVERLINK
	chmod u+x $FILENAME
else 
	echo "File Exist: Skiping downloading"
fi

# @brief Generate a UEFI key for signing the NVIDIA driver.
# This section runs only if the system is UEFI-enabled.
if [ -d /sys/firmware/efi ]; then
	if [[ ! -f /root/UEFI.der ]] || [[ ! -f /root/UEFI.der ]] ; then
		openssl req -new -x509 -newkey rsa:2048 -keyout UEFI.key -outform DER -out UEFI.der -passin pass:$PASSWORD -nodes -days 36500 -subj "/CN=tirsvad_nvidia/"
		printf "$PASSWORD\n$PASSWORD\n" | mokutil --import UEFI.der
	fi
fi

# @brief Create temporary script and service for installation step 1.
cat <<EOT >> /usr/local/bin/runonetime-nvidia-installer-step-01.sh
#!/bin/bash
exec 3>&1 1>>/root/runonetime-nvidia-installer-step-01.log 2>&1
DEBIAN_FRONTEND=noninteractive apt-get remove nvidia* && sudo apt-get autoremove
echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nouveau.conf
echo "blacklist lbm-nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
echo "alias nouveau off" >> /etc/modprobe.d/blacklist-nouveau.conf
echo "alias lbm-nouveau off" >> /etc/modprobe.d/blacklist-nouveau.conf
grep -qxF 'options nouveau modeset=0' /etc/modprobe.d/nouveau-kms.conf || echo 'options nouveau modeset=0' >> /etc/modprobe.d/nouveau-kms.conf
update-initramfs -u
systemctl disable runonetime-nvidia-installer-step-01.service
systemctl enable runonetime-nvidia-installer-step-02.service
rm /usr/local/bin/runonetime-nvidia-installer-step-01.sh
rm /etc/systemd/system/runonetime-nvidia-installer-step-01.service
reboot
EOT

chmod +x /usr/local/bin/runonetime-nvidia-installer-step-01.sh

# @brief Create systemd service for installation step 1.
cat <<EOT >> /etc/systemd/system/runonetime-nvidia-installer-step-01.service
[Unit]
Description=Simple one time run

[Service]
Type=simple
ExecStart=/bin/bash -c '/usr/local/bin/runonetime-nvidia-installer-step-01.sh'

[Install]
WantedBy=multi-user.target
EOT

chmod 644 /etc/systemd/system/runonetime-nvidia-installer-step-01.service

# Script part 2

cat <<EOT >> /usr/local/bin/runonetime-nvidia-installer-step-02.sh
#!/bin/bash
exec 3>&1 1>>/root/runonetime-nvidia-installer-step-02.log 2>&1
cd /root
if [ -d /sys/firmware/efi ]; then
    ./$FILENAME -s --module-signing-secret-key=/root/UEFI.key --module-signing-public-key=/root/UEFI.der
else
    ./$FILENAME -s
fi
systemctl set-default graphical.target
systemctl disable runonetime-nvidia-installer-step-02.service
rm /usr/local/bin/runonetime-nvidia-installer-step-02.sh
/etc/systemd/system/runonetime-nvidia-installer-step-02.service
shutdown -r now
EOT

chmod +x /usr/local/bin/runonetime-nvidia-installer-step-02.sh

# @brief Create systemd service for installation step 2.
cat <<EOT >> /etc/systemd/system/runonetime-nvidia-installer-step-02.service
[Unit]
Description=Simple one time run
Requires=network-online.target
After=network-online.target systemd-networkd.service

[Service]
Type=simple
ExecStart=/bin/bash -c '/usr/local/bin/runonetime-nvidia-installer-step-02.sh'

[Install]
WantedBy=multi-user.target
EOT

chmod 644 /etc/systemd/system/runonetime-nvidia-installer-step-02.service

# @brief Enable the scripts to run at boot and set the default target.
systemctl enable runonetime-nvidia-installer-step-01.service
systemctl set-default multi-user.target
systemctl daemon-reload

shutdown -r now
