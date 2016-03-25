#!/bin/sh
# Nintendo Home Relay Service v1.2
# For OpenWRT Routers running BusyBox
# By TonyFuckFingers
#
# Ensure you WiFi name is set to 'attwifi'
# It is recommended to have WiFi encryption OFF.
# Use MAC address white lists and limit transmit range for security.
# Set your CRONTAB to run this script at the desired frequency.
# Usage example (If script files located in /usr/share/NHRS):
#     * * * * * cd /usr/share/NHRS && sh NHRS.sh
#     Would trigger this script every minute
# If configured correctly, this script will automatically
#     run even if your router resets.

# Read how many MAC addresses are in the StreetPass.list and save to file.
`wc -l < StreetPass.list > maclist.len`

# Declare the next position in the queue according to queue.pos
POSITION=`awk 'NR==1' queue.pos`

# Declare the maclist.len as a variable to help determine when to reset list.
MACLISTLEN=`awk 'NR==1' maclist.len`

# Print/ declare MAC address from StreetPass.list
echo "The next MAC address to be set is:"
echo `awk NR==$POSITION "StreetPass.list"`
SETMAC=`awk NR==$POSITION "StreetPass.list"`

# Increment POSITION by 1 and echo
NPOSIT=`expr $POSITION + 1`

# Set the Wifi MAC address. The next three lines is the money shot here.
echo "Setting WiFi MAC address"
`uci set wireless.@wifi-iface[0].macaddr=$SETMAC`
`uci commit wireless`
`wifi`

# Reset queue to 1 when list exhausted
if [ $NPOSIT -gt $MACLISTLEN ]; then
        echo "In IF statement"
                NPOSIT=1
fi

# Closing message
echo "MAC address has been set. Next MAC address will be:"
echo `awk NR==$NPOSIT "StreetPass.list"`

# Write NPOSIT to queue.pos file
echo $NPOSIT > 'queue.pos'
