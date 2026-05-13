# Prerequisite

You need to accept EULA to run this server, you can do so by adding the following environment variable to the service configuration:

```yaml
environment:
  - EULA=true
```

# Increasing RAM Allocation

If you need to increase the RAM (by default it's 8GB), you can do so by adding the following environment variable to the service configuration:

```yaml
environment:
  - ALLOCATED_RAM=8G
```

# Example

```yaml
services:
  cobblemon:
    image: delath/cobblemon
    container_name: cobblemon
    ports:
      - "25565:25565/tcp"
    volumes:
      - ./world:/home/cobblemon/world
    restart: 'unless-stopped'
    environment:
      - ALLOCATED_RAM=12G
      - EULA=true
```

# Sending commands to the server console

If you want to send commands to the console you can leverage minecraft official rcon support, you would need to generate all server files by starting the server at least once and edit the `server.properties` rcon related fields 
```txt
enable-rcon=true
rcon.port=25575
rcon.password=<rcon_password>
```

Then you can send any command with the following syntax
```bash
docker exec -it cobblemon sh -c "rcon -H localhost -p 25575 -P <rcon_password> <command>"
```
