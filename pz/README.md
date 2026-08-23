# Custom configuration

If you want to change the default configuration, you can do so by adding a set of environment variables to the docker compose.

SERVERNAME Is the name of your server. This dictates the name of your `.ini` config file and the save folder.
  ```yaml
  environment:
    - SERVERNAME=servertest
  ```

ADMINPASSWORD Is the password for the admin account. Project Zomboid requires this to be set on the first boot.
  ```yaml
  environment:
    - ADMINPASSWORD=Password
  ```

# World and Server Settings Customization

To configure gameplay rules (such as water/electricity shutoff dates, zombie population, loot rarity, or join passwords) before world generation occurs:
1. Launch Project Zomboid on your local machine.
2. Go to Host > Manage Settings > Create New Settings.
3. Name the settings preset to match your SERVERNAME variable (e.g., servertest).
4. Adjust your settings as desired and save.
5. Navigate to your local settings directory:
  - Windows: C:\Users\<YourUser>\Zomboid\Server\
  - Linux: ~/Zomboid/Server/
6. Copy the four generated files (<SERVERNAME>.ini, <SERVERNAME>_SandboxVars.lua, <SERVERNAME>_spawnpoints.lua, <SERVERNAME>_spawnregions.lua) into the ./Zomboid/Server/ directory on your Docker host before starting the container for the first time.

# Example

```yaml
services:
  pz:
    image: delath/pz
    container_name: pz
    ports:
      - "16261:16261/udp"
      - "16262:16262/udp"
    volumes:
      - ./Zomboid:/home/pzuser/Zomboid
      - ./Server:/home/pzuser/server
    restart: 'unless-stopped'
    environment:
      - SERVERNAME=servertest
      - ADMINPASSWORD=Password
```
