# Kali Linux RDP with Ngrok

This Docker container provides a Kali Linux environment with RDP access via ngrok.

## Features

- Kali Linux Rolling base
- XFCE4 desktop environment
- XRDP server for remote desktop access
- Ngrok tunnel for external access
- Pre-configured to prevent blue screen issues

## Credentials

- Username: `root`
- Password: `Devil`

## Usage

1. Build the Docker image:
```bash
docker build -t kali-rdp-ngrok .
```

2. Run the container:
```bash
docker run -d -p 3389:3389 kali-rdp-ngrok
```

3. Check the logs to get the ngrok URL:
```bash
docker logs <container_id>
```

4. Connect via RDP using the ngrok URL with the credentials above.

## Blue Screen Fix

The blue screen issue in RDP has been resolved by:
- Configuring proper XRDP startwm.sh script
- Setting up .xsession for XFCE4
- Unsetting conflicting DBUS environment variables
- Properly starting the XFCE4 session manager

## Notes

- The ngrok authtoken is already configured in `ngrok.yml`
- Port 3389 is exposed for RDP connections
- The container runs services in the background and stays alive
