#!/bin/sh

if [ -z "$SERVERNAME" ]; then
    SERVERNAME="servertest"
fi
if [ -z "$ADMINPASSWORD" ]; then
    echo "Variable ADMINPASSWORD not defined, see docs, it must be present."
    exit 1
fi


mkdir -p /home/pzuser/server
mkdir -p /home/pzuser/Zomboid

mkdir -p ~/Steam && cd ~/Steam

curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

./steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir /home/pzuser/server +login anonymous +app_update 380870 validate +quit

cd /home/pzuser/server

chown -R pzuser:pzuser /home/pzuser

echo "Starting server PRESS CTRL-C to exit"  

# Project Zomboid requires an admin password on the first run; passing it as an argument prevents the console from hanging
su -c "/home/pzuser/server/start-server.sh -servername \"$SERVERNAME\" -adminpassword \"$ADMINPASSWORD\"" pzuser