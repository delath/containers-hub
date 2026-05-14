#!/bin/ash

# Check if EULA has been accepted
if [ -z "$EULA" ]; then
    echo "Variable EULA not defined, see docs to know how to accept EULA."
    exit 1
fi

cd /home/minecraft/world

# Fetch latest Paper jar name and version from API
LATEST_VERSION=$(wget -qO- https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')
LATEST_BUILD=$(wget -qO- "https://api.papermc.io/v2/projects/paper/versions/${LATEST_VERSION}/builds" | jq -r '.builds[-1].build')
API_FULL_VERSION="${LATEST_VERSION}-${LATEST_BUILD}"
JAR_NAME="paper-${LATEST_VERSION}-${LATEST_BUILD}.jar"

# Determine current local version
LOCAL_VERSION="0.0.0"
if [ -f "version.txt" ]; then
    LOCAL_VERSION=$(cat version.txt)
fi

# Compare versions using GNU sort -V (Version sort)
HIGHEST_VERSION=$(printf '%s\n' "$LOCAL_VERSION" "$API_FULL_VERSION" | sort -V | tail -n1)

if [ "$HIGHEST_VERSION" = "$API_FULL_VERSION" ] && [ "$LOCAL_VERSION" != "$API_FULL_VERSION" ]; then
    echo "Newer version found on API ($API_FULL_VERSION). Current is $LOCAL_VERSION."
    echo "Downloading Paper version ${LATEST_VERSION} build ${LATEST_BUILD}..."
    wget -O paper.jar "https://api.papermc.io/v2/projects/paper/versions/${LATEST_VERSION}/builds/${LATEST_BUILD}/downloads/${JAR_NAME}"

    # Fail-safe: Ensure the jar downloaded successfully before continuing
    if [ ! -f paper.jar ] || [ ! -s paper.jar ]; then
        echo "Error: Failed to download paper.jar from PaperMC API."
        exit 1
    fi
    
    # Update local version tracker
    echo "$API_FULL_VERSION" > version.txt
else
    echo "Local version ($LOCAL_VERSION) is up-to-date or newer than API ($API_FULL_VERSION). Skipping download."
fi

# Default the allocated ram to 4G if not set
if [ -z "$ALLOCATED_RAM" ]; then
    echo "Variable ALLOCATED_RAM not defined."
    ALLOCATED_RAM="4G"
fi

sleep 5m

echo "eula=${EULA}" > eula.txt
chown -R minecraft:minecraft /home/minecraft
chmod +x paper.jar
su -c "java -Xmx${ALLOCATED_RAM} -Xms${ALLOCATED_RAM} -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paper.jar --nogui" minecraft