FROM steamcmd/steamcmd:alpine-3

# Install prerequisites, including su-exec for privilege dropping
RUN apk update \
 && apk add --no-cache bash curl tmux libstdc++ libgcc icu-libs su-exec \
 && rm -rf /var/cache/apk/*

# Fix 32 and 64 bit library conflicts
RUN mkdir /steamlib \
 && mv /lib/libstdc++.so.6 /steamlib \
 && mv /lib/libgcc_s.so.1 /steamlib
ENV LD_LIBRARY_PATH /steamlib

# Set a specific tModLoader version, defaults to the latest Github release
ARG TML_VERSION

# Create tModLoader user but DO NOT switch to it yet.
# The container will start as root to fix permissions.
ARG UID
ARG GID
RUN addgroup -g ${GID:-1000} tml \
 && adduser tml -u ${UID:-1000} -G tml -h /home/tml -D

# Switch to the tml user's home directory for subsequent commands
WORKDIR /home/tml

# Update SteamCMD and verify latest version
RUN steamcmd +quit

# Copy the management script and the new entrypoint script
COPY --chown=tml:tml manage-tModLoaderServer.sh .
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make scripts executable
RUN chmod +x manage-tModLoaderServer.sh \
 && chmod +x /usr/local/bin/entrypoint.sh

# Run the tModLoader installation as the tml user
RUN su-exec tml ./manage-tModLoaderServer.sh install-tml --github --tml-version $TML_VERSION

EXPOSE 7777

# Set the new entrypoint script to run on container start.
# This script will handle permissions and then execute the CMD.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# The CMD is now defined in the docker-compose file to include our config generation.
CMD ["./manage-tModLoaderServer.sh", "docker", "--folder", "/home/tml/.local/share/Terraria/tModLoader"]