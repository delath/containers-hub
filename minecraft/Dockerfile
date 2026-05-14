# Use Alpine because it's more secure, more performant and more size friendly
FROM alpine:3.23

# Install everything we need
RUN apk add --no-cache \
    openjdk25-jre \
    jq \
    rcon\
    coreutils

# Create a user and usergroup with high UID and GID to not overlap with an existing host user or usergroup
RUN addgroup -g 10001 minecraft && \
    adduser -D -u 10000 -G minecraft minecraft

# Set working directory
WORKDIR /home/minecraft

# Copy the entrypoint script
COPY minecraft.sh ./

# Fix entrypoint script permissions
RUN chown minecraft:minecraft minecraft.sh && \
    chmod +x minecraft.sh

# USER is not being used, but we are actually running the server as the minecraft user inside the entrypoint
# The reason is conflicts with volumes permissions while wanting to have this streamlined as much as possible 

# Launch entrypoint script to run the server
ENTRYPOINT ["/home/minecraft/minecraft.sh"]