# docker-dropbox
A docker image for syncing data with a Dropbox account.

### Description
This image was created to utilize Dropbox as a backup space for a server. 
The contents of the linked Dropbox account is synced to the `/root/Dropbox` directory.
The folder itself or contained subdirectories can be bound to docker volumes and used by other containers to store data.

Dropbox has an interesting behaviour. 
It updates itself by downloading new binaries and restarting it's process.
Usually Docker images are built with the contained service binary as startup command.
This starts it with PID 1.
When the process with PID 1 stops, the container shuts down.
That is a standard docker behaviour.
This combination of behaviours leeds to an infinite shutdown and restart of the container when Dropbox decides to update.

To mitigate this problem, this image is built with a supervisor script to be run as PID 1.
This way dropbox can restart without docker stopping the container.
When the container is stopped by the host, the supervisor receives the KILL signal ans stops the Dropbox process.

### Installation

Create the container

`docker create --name dropbox -v dropbox-data:/root/Dropbox -v dropbox-config:/root/.dropbox nilsramsperger/dropbox`

In this case the Dropbox base directory is bound to the `dropbox-data` volume. 
Change it as you like.

`/root/.dropbox` bound to `dropbox-config` holds the configuration and is used to keep up the link between container recreations.

After creating the container, start it using `docker start dropbox`.
Check `docker logs dropbox`.
The output will contain a URL with a nonce to create the link to Dropbox.
Open the URL in any browser on any computer you like and log into Dropbox with the credentials of the account you want to link.
After logging in successfully, syncing should start immediately.