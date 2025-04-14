# ZeroTier Setup Script for OpenWRT

## Overview:
This script automates the installation and configuration of ZeroTier on OpenWRT devices. It will:
1. Install the ZeroTier package using `opkg`.
2. Configure the `/etc/config/zerotier` file to enable ZeroTier and set the network ID.
3. Modify firewall settings to allow ZeroTier traffic.
4. Restart the necessary services (`zerotier` and `firewall`).

## How to Use:
1. SSH into your OpenWRT device.
2. Run the following command to execute the installation and setup script:

```sh
sh <(wget -O - https://raw.githubusercontent.com/DoNBaLooN/zerotier-setup-openwrt/main/install.sh)
