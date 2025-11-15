# Fedora Code-Server with Ngrok

This Docker container runs code-server (VS Code in the browser) on Fedora 43, accessible via ngrok tunnel.

## Features

- **Code-Server** - VS Code running in your browser
- **Fedora 43** - Latest stable Fedora base
- **Ngrok tunnel** - Secure external access
- **Git and Node.js** - Pre-installed development tools
- **Lightweight** - No desktop environment, just the essentials

## Credentials

- **Code-Server Access**:
  - Password: `Devil` (can be customized via `CODE_SERVER_PASSWORD` environment variable)

## Usage

### Deploy on Render.com (Recommended)

1. Fork this repository to your GitHub account
2. Go to [Render.com](https://render.com) and sign in
3. Click "New +" and select "Blueprint"
4. Connect your GitHub repository
5. Render will automatically detect the `render.yaml` file
6. (Optional) Add environment variables:
   - `NGROK_AUTHTOKEN` - Your ngrok authtoken (optional, has default)
   - `CODE_SERVER_PASSWORD` - Custom password for code-server (optional, defaults to "Devil")
7. Click "Apply" to deploy
8. Check the logs to see the ngrok URL for accessing code-server

The service will start code-server and automatically print the access URL in the logs.

### Run Locally with Docker

1. Build the Docker image:
```bash
docker build -t fedora-code-server-ngrok .
```

2. Run the container:
```bash
docker run -d -p 8080:8080 fedora-code-server-ngrok
```

Or with custom configuration:
```bash
docker run -d -p 8080:8080 \
  -e NGROK_AUTHTOKEN=your_token_here \
  -e CODE_SERVER_PASSWORD=your_password_here \
  fedora-code-server-ngrok
```

3. Check the logs to get the ngrok URL:
```bash
docker logs -f <container_id>
```

The startup script will automatically display the code-server access URL and password.

4. Open the URL in your browser and enter the password to access code-server.

## Connection Configuration

This container runs code-server on Fedora 43:

### Code-Server Access
- **code-server** - VS Code running in the browser on port 8080
- Password authentication (default: "Devil")
- Full VS Code experience with extensions support
- Git and Node.js pre-installed
- Ngrok HTTP tunnel for secure external access

### Connection Details

After deployment:
1. Check the container logs for the ngrok URL
2. **Code-Server Connection:**
   - Open the ngrok URL in any web browser
   - Enter the password (default: `Devil`)
   - You'll have access to a full VS Code environment in your browser
   - Pre-installed tools: Git, Node.js, npm

## Notes

- The ngrok authtoken can be customized via the `NGROK_AUTHTOKEN` environment variable
- If `NGROK_AUTHTOKEN` is not set, a default token is used (pre-configured)
- The code-server password can be customized via the `CODE_SERVER_PASSWORD` environment variable
- Port 8080 is used for code-server
- After deployment, the ngrok tunnel URL will be printed in the logs
- The startup script (`start.sh`) automatically displays code-server access information
- Lightweight setup - no desktop environment, no VMs
- Fast startup - ready in seconds

## Render.com Configuration

The `render.yaml` file is pre-configured for easy deployment:
- Deploys as a web service
- Uses the free plan
- Auto-deploys on code changes
- Exposes port 8080 (code-server)
- Supports custom ngrok authtoken and password via environment variables

## Testing the Configuration

To verify the setup is working correctly:

1. **Check QEMU VM**: After container starts, verify QEMU is running:
   ```bash
   docker exec <container_id> ps aux | grep qemu
   docker logs <container_id>
   ```

2. **Test RDP Connection**:
   - Wait 3-5 minutes for the VM to fully boot
   - Use the RDP ngrok URL from logs (format: `hostname:port`)
   - Connect with any RDP client
   - Enter credentials: root / Devil
   - Expected behavior: Fedora 43 GNOME 49 desktop should load

3. **Verify QEMU VM**: After connecting via RDP, open a terminal in the VM:
   ```bash
   cat /etc/fedora-release  # Should show Fedora version
   echo $XDG_CURRENT_DESKTOP  # Should output: GNOME
   gnome-shell --version  # Should show GNOME version
   ```

## QEMU VM Configuration

This setup uses **QEMU virtualization** to run a complete Fedora 43 installation with GNOME 49 desktop:

- **True Virtual Machine**: Complete Fedora 43 OS running in QEMU
- **Full GNOME 49 Desktop**: Authentic Fedora Workstation experience with GNOME 49.1
- **Hardware Virtualization**: Uses KVM acceleration when available for optimal performance
- **Cloud-Init Setup**: Automatic configuration on first boot
- **RDP Access**: xrdp server configured inside the VM for remote access

**VM Specifications**:
- Memory: 4GB RAM (configurable)
- CPUs: 2 cores (configurable)
- Disk: 20GB virtual disk
- Display: VirtIO GPU with software rendering

**Why QEMU VM**:
- Provides the most authentic Fedora 43 experience
- Complete OS isolation and full system access
- Proper hardware emulation
- Supports all Fedora features and applications
- Can be customized and configured like a real Fedora installation

**Performance Notes**:
- First boot takes 3-5 minutes for initial setup and GNOME installation
- Subsequent boots are faster (typically 1-2 minutes)
- KVM acceleration significantly improves performance when available
- Runs efficiently on cloud platforms like Render.com

## Troubleshooting

If you don't see the ngrok URL in the logs immediately:
1. Wait 30-60 seconds for ngrok to establish the tunnel
2. Check the full logs with `docker logs -f <container_id>` or in Render dashboard
3. The URL will appear in format: `Host: X.tcp.ngrok.io:XXXXX`

If the VM takes too long to boot:
1. First boot takes 3-5 minutes for initial setup
2. Check QEMU is running:
   ```bash
   docker exec <container_id> ps aux | grep qemu
   ```
3. Monitor the container logs for progress updates
4. Subsequent boots will be faster (1-2 minutes)

If you experience RDP connection issues:
1. Verify the QEMU VM is running:
   ```bash
   docker exec <container_id> ps aux | grep qemu-system
   ```
2. Check if the VM has fully booted (wait at least 5 minutes on first boot)
3. Try connecting again after a few minutes
4. If running locally, test connection to localhost:3389

If QEMU fails to start:
1. Ensure the container is running with `--privileged` flag
2. Check available disk space in the container
3. Review container logs for QEMU error messages
4. Verify the cloud image downloaded successfully

### Common RDP Client Configuration Tips

**RDP Clients:**
- **Microsoft Remote Desktop (Windows)**: Enter `hostname:port` directly in Computer field
- **Microsoft Remote Desktop (macOS/iOS)**: Add PC, enter `hostname:port`
- **Remmina (Linux)**: Select RDP protocol, enter `hostname:port`
- **FreeRDP/xfreerdp**: Use command like `xfreerdp /v:hostname:port /u:root /p:Devil`

### Performance Tips

- Ensure KVM is available for hardware acceleration
- Increase VM memory if experiencing slowness (edit `VM_MEMORY` in start.sh)
- Allow adequate time for first boot GNOME installation
- Render.com free tier provides sufficient resources for smooth operation
