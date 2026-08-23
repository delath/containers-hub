# Use Debian because glibc is a dependency of SteamCMD
FROM debian:12-slim

# Install everything we need
RUN apt-get update && apt-get install -y \
    lib32gcc-s1 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and install a standalone rcon client
RUN curl -sqL "https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz" | tar zxvf - -C /usr/local/bin/ rcon-0.10.3-amd64_linux/rcon --strip-components=1

# Create a user and usergroup with high UID and GID to not overlap with an existing host user or usergroup
RUN addgroup -gid 10001 pzuser && \
    adduser -disabled-password -u 10000 -ingroup pzuser pzuser

# Set working directory
WORKDIR /home/pzuser

# Copy the entrypoint script
COPY pz.sh ./

# Fix the entrypoint script permissions
RUN chown pzuser:pzuser pz.sh && \
    chmod +x pz.sh

# USER is not being used, but we are actually running the server as the pzuser user inside the entrypoint
# The reason is conflicts with volumes permissions while wanting to have this streamlined as much as possible 

# Launch entrypoint script to run the server
ENTRYPOINT ["/home/pzuser/pz.sh"]