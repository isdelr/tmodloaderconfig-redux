# tModLoader Docker Server - Professional Edition

This setup provides a clean, unified, and easy-to-manage tModLoader dedicated server using Docker Compose. It automates permissions and allows for server and mod configuration directly from the `docker-compose.yml` file.

## Features

-   **Unified Configuration**: All major server settings are managed via environment variables.
-   **Automated Mod Installation**: Provide your mod lists directly in the `docker-compose.yml` or as files. Mods from the Steam Workshop are downloaded automatically.
-   **Automatic `serverconfig.txt` Generation**: The server automatically creates a `serverconfig.txt` on the first run based on your settings.
-   **Automated Permissions**: The container automatically fixes file permissions on the host data directory, so no manual `sudo` commands are needed.
-   **Persistent Data**: Your world, mods, and logs are stored in a `./tmodloader_data` folder on the host.

## Prerequisites

1.  **Docker and Docker Compose**: Install them from the [official Docker website](https://docs.docker.com/engine/install/).

## Quick Start

1.  **Create Your Server Directory**:
    Create a new, empty folder and place the following four files inside it:
    -   `docker-compose.yml`
    -   `Dockerfile`
    -   `entrypoint.sh`
    -   `manage-tModLoaderServer.sh`

2.  **Configure Your Server**:
    Open `docker-compose.yml` and edit the `environment` section. You can set the world name, max players, password, and more.

3.  **Configure Mods**:
    Choose **one** of the two methods below to configure your mods in the `docker-compose.yml` file under the "Mod Installation" section.

    *   **Method A: Paste Content Directly (Recommended)**
        This is the easiest way. Paste the content of your `install.txt` (Steam Workshop File IDs) and `enabled.json` (mod names) directly into the `TML_INSTALL_TXT_CONTENT` and `TML_ENABLED_JSON_CONTENT` variables.

    *   **Method B: Use File Paths**
        1.  Create the data directory: `mkdir tmodloader_data`
        2.  Place your mod list files (e.g., `my_install.txt`, `my_enabled.json`) inside the `./tmodloader_data` directory.
        3.  In `docker-compose.yml`, comment out the `_CONTENT` variables and uncomment the `_PATH` variables, setting them to your filenames. For example: `TML_INSTALL_TXT_PATH: my_install.txt`.

4.  **Launch the Server**:
    Open a terminal in your server folder and run:
    ```bash
    docker compose up -d --build
    ```
    -   `-d`: Runs the server in the background (detached mode).
    -   `--build`: This should be used on the first run and whenever you change the `Dockerfile` or `entrypoint.sh`.

5.  **Access the Server Console**:
    To interact with the server console, run:
    ```bash
    docker attach tmodloader_server
    ```
    To detach without stopping the server, press `Ctrl+P` then `Ctrl+Q`.

6.  **Stopping the Server**:
    To stop the server, run:
    ```bash
    docker compose down
    ```

## How to Get `install.txt` and `enabled.json`

The easiest way to get these files is to create a Mod Pack from the in-game Workshop menu:
1.  Go to **Workshop > Mod Packs**.
2.  Click **"Save Enabled as New Mod Pack"**.
3.  Click **"Open Mod Pack Folder"**.
4.  Find the folder with your Mod Pack's name and open it. You will find `install.txt` and `enabled.json` inside.