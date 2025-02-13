#!/bin/ash

# Check if EULA has been accepted
if [ -z "$EULA" ]; then
    echo "Variable EULA not defined, see docs to know how to accept EULA."
    exit 1
fi

# Set versions for fabric jar
MINECRAFT_VERSION=1.21.1
FABRIC_LOADER_VERSION=0.16.10
INSTALLER_VERSION=1.0.1
COBBLEMON_VERSION=1.6.1

# Default the allocated ram to 8G if not set
if [ -z "$ALLOCATED_RAM" ]; then
    echo "Variable ALLOCATED_RAM not defined."
    ALLOCATED_RAM="8G"
fi

# Install the Fabric API mod -> https://modrinth.com/mod/fabric-api
mkdir /home/cobblemon/world/mods
cd /home/cobblemon/world/mods
wget "https://cdn.modrinth.com/data/5FFgwNNP/versions/cqaC80tF/Cobblemon%20Official%20%5BFabric%5D%20${COBBLEMON_VERSION}.mrpack"

# Download the Fabric jar and launch it -> https://fabricmc.net/use/server/
cd /home/cobblemon/world
wget -O fabric-server-mc-loader-launcher.jar "https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${FABRIC_LOADER_VERSION}/${INSTALLER_VERSION}/server/jar"
echo "eula=${EULA}" > eula.txt
chown -R cobblemon:cobblemon /home/cobblemon
chmod +x fabric-server-mc-loader-launcher.jar
su -c "java -Xmx${ALLOCATED_RAM} -jar fabric-server-mc-loader-launcher.jar nogui" cobblemon