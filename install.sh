#!/bin/sh

# 1. Install ZeroTier
opkg install zerotier

# 2. Enable ZeroTier
ZT_CONF="/etc/config/zerotier"
# Check if the line to enable ZeroTier exists and modify it
if grep -q "option enabled" "$ZT_CONF"; then
    # If the line is found, change it to option enabled '1'
    awk '/option enabled/ { $0="	option enabled 1"; print $0; next } { print $0 }' "$ZT_CONF" > "$ZT_CONF.tmp" && mv "$ZT_CONF.tmp" "$ZT_CONF"
else
    echo "Error: 'option enabled' not found in $ZT_CONF"
    exit 1
fi

# 3. Request ZeroTier network ID
echo "Enter your ZeroTier network ID:"
read ZT_ID

# 4. Set the network ID
if grep -q "option id" "$ZT_CONF"; then
    sed -i "s/option id '.*'/option id '$ZT_ID'/" "$ZT_CONF"
else
    echo "Error: 'option id' not found in $ZT_CONF"
    exit 1
fi

# 5. Configure firewall
FW_CONF="/etc/config/firewall"
cat <<EOF >> "$FW_CONF"

config zone 'vpn_zone'
	option name 'zerotier'
	option input 'ACCEPT'
	option forward 'REJECT'
	option output 'ACCEPT'
	option device 'zt+'
	option masq '1'
	option mtu_fix '1'

config forwarding
	option dest 'zerotier'
	option src 'lan'

config forwarding
	option dest 'lan'
	option src 'zerotier'
EOF

# 6. Restart services
/etc/init.d/zerotier restart
/etc/init.d/firewall restart

# 7. Done
echo "ZeroTier has been configured and started successfully."
