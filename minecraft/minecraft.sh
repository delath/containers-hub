#!/bin/ash

# Check if EULA has been accepted
if [ -z "$EULA" ]; then
    echo "Variable EULA not defined, see docs to know how to accept EULA."
    exit 1
fi

# Fetch latest Paper jar name
LATEST_VERSION=$(wget -qO- https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')
LATEST_BUILD=$(wget -qO- "https://api.papermc.io/v2/projects/paper/versions/${LATEST_VERSION}/builds" | jq -r '.builds | map(select(.channel == "default") | .build) | .[-1]')
JAR_NAME=paper-${LATEST_VERSION}-${LATEST_BUILD}.jar

# Default the allocated ram to 4G if not set
if [ -z "$ALLOCATED_RAM" ]; then
    echo "Variable ALLOCATED_RAM not defined."
    ALLOCATED_RAM="4G"
fi

# Download the latest Paper jar and launch it with Aikar's Flags -> https://docs.papermc.io/paper/aikars-flags
cd /home/minecraft/world
wget -O paper.jar "https://api.papermc.io/v2/projects/paper/versions/${LATEST_VERSION}/builds/${LATEST_BUILD}/downloads/${JAR_NAME}"
echo "eula=${EULA}" > eula.txt
chown -R minecraft:minecraft /home/minecraft
chmod +x paper.jar
su -c "java -Xmx${ALLOCATED_RAM} -Xms${ALLOCATED_RAM} -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paper.jar --nogui" minecraft