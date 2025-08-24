# tModLoader Docker Server - Professional Edition

This setup provides a clean, unified, and easy-to-manage tModLoader dedicated server using Docker Compose. It is based on the official tModLoader server files but has been refactored for simplicity and ease of configuration.

## Features

-   **Unified Configuration**: All major server settings are managed via environment variables in the `docker-compose.yml` file.
-   **Automatic `serverconfig.txt` Generation**: The server automatically creates a `serverconfig.txt` on the first run based on your settings.
-   **Non-Root User**: Runs the server under a non-root user for better security.
-   **Persistent Data**: Your world, mods, and logs are stored on the host machine in a `tmodloader_data` folder, so your data persists even if the container is removed.
-   **Easy Updates**: Rebuild your container to update tModLoader and your workshop mods automatically.

## Prerequisites

1.  **Docker and Docker Compose**: Install them from the [official Docker website](https://docs.docker.com/engine/install/).

## Quick Start

1.  **Download Files**:
    Place the following files in a new, empty folder for your server:
    -   `docker-compose.yml`
    -   `Dockerfile`
    -   `manage-tModLoaderServer.sh`

2.  **Configure Your Server**:
    Open the `docker-compose.yml` file and edit the `environment` section to your liking. You can set the world name, max players, password, and more.

3.  **Install Mods (Optional)**:
    -   Create a folder named `tmodloader_data`, and inside it, another folder named `Mods`. (`your-server-folder/tmodloader_data/Mods`)
    -   Inside the `Mods` folder, create two files:
        -   `install.txt`: A list of Steam Workshop File IDs for the mods you want, one ID per line.
        -   `enabled.json`: The list of mods to enable. The easiest way to get this file is to create a Mod Pack in-game and copy the `enabled.json` from the Mod Pack's folder.
    -   These files will be used to automatically download and enable your mods when the server starts.

4.  **Launch the Server**:
    Open a terminal in your server folder and run:
    ```bash
    docker compose up -d --build
    ```
    -   `-d`: Runs the server in the background (detached mode).
    -   `--build`: Builds the Docker image. You should use this on the first run and whenever you change the `TML_VERSION` or update the `manage-tModLoaderServer.sh` script.

5.  **Access the Server Console**:
    To interact with the server console (e.g., to issue commands), run:
    ```bash
    docker attach tmodloader_server
    ```
    To detach without stopping the server, press `Ctrl+P` followed by `Ctrl+Q`.

6.  **Stopping the Server**:
    To stop the server, run:
    ```bash
    docker compose down
    ```

## Configuration Details

All configuration is handled in the `docker-compose.yml` file under the `environment` section.

| Variable              | Description                                                                                                   | Default          |
| --------------------- | ------------------------------------------------------------------------------------------------------------- | ---------------- |
| `TML_PORT`            | The external port for the server.                                                                             | `7777`           |
| `TML_WORLD_NAME`      | The name of the world to be generated if `TML_AUTOCREATE` is enabled.                                           | `Terraria`       |
| `TML_MAX_PLAYERS`     | The maximum number of players allowed on the server.                                                          | `8`              |
| `TML_PASSWORD`        | The server password. Leave blank for no password.                                                             | (none)           |
| `TML_MOTD`            | The Message of the Day displayed to players upon joining.                                                     | (Welcome message) |
| `TML_AUTOCREATE`      | `1` for Small, `2` for Medium, `3` for Large world. Set to `0` to disable auto-creation.                      | `1`              |
| `TML_WORLD_FILE`      | The filename of an existing world to load (e.g., `MyWorld.wld`). This will override auto-creation.             | (none)           |
| `TML_EXTRA_ARGS`      | Any additional command-line arguments to pass to the server, such as `-steam` or `-lobby friends`.            | (none)           |

For file permissions, you can also set the `UID` and `GID` in the `docker-compose.yml` file's `build.args` section to match your user on the host system. You can find these by running `id -u` and `id -g` in your terminal.