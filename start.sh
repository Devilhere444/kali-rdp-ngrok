#!/bin/bash

set -e

# Install ngrok if not present
if ! command -v ngrok &> /dev/null; then
    echo "Installing ngrok..."
    curl -fsSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -o /tmp/ngrok.tgz && \
    tar -xzf /tmp/ngrok.tgz -C /usr/local/bin && \
    chmod +x /usr/local/bin/ngrok && \
    rm /tmp/ngrok.tgz
    echo "✓ ngrok installed"
fi

echo "============================================"
echo "  Fedora Code-Server Setup"
echo "============================================"
echo ""

# Get ngrok authtoken from environment variable or use default
NGROK_TOKEN="${NGROK_AUTHTOKEN:-35SfwXIN64gkw59BROC10ZONXJB_6SqDctBbRwcTpxsW3moKX}"

# Get code-server password from environment variable or use default
CODE_SERVER_PASSWORD="${CODE_SERVER_PASSWORD:-Devil}"

# Generate ngrok configuration
echo "Generating ngrok configuration..."
mkdir -p /root/.ngrok2
cat > /root/.ngrok2/ngrok.yml << EOF
version: "3"
agent:
  authtoken: ${NGROK_TOKEN}
tunnels:
  code-server:
    proto: http
    addr: 127.0.0.1:8080
EOF
echo "✓ ngrok configuration created"

# Start ngrok in the background
echo "Starting ngrok tunnel for code-server..."
ngrok start --all --config /root/.ngrok2/ngrok.yml --log=stdout > /tmp/ngrok.log 2>&1 &

# Wait for ngrok to establish connection
sleep 5

# Display connection information
echo ""
echo "Starting code-server..."
echo "Configuration:"
echo "  Port: 8080"
echo "  Password: ${CODE_SERVER_PASSWORD}"
echo ""

# Start code-server in the background
code-server --bind-addr 0.0.0.0:8080 --auth password --disable-telemetry > /tmp/code-server.log 2>&1 &

# Wait for code-server to start
sleep 3

echo "✓ code-server started"
echo ""

# Display connection information
echo "============================================"
echo "  Fedora Code-Server is ready!"
echo "============================================"
echo ""
echo "Access Credentials:"
echo "  Password: ${CODE_SERVER_PASSWORD}"
echo ""

# Try to get the code-server tunnel URL from ngrok API
for i in {1..10}; do
    TUNNELS_JSON=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null)
    if [ ! -z "$TUNNELS_JSON" ]; then
        CODE_SERVER_URL=$(echo "$TUNNELS_JSON" | grep -o '"name":"code-server"[^}]*"public_url":"[^"]*' | grep -o 'https://[^"]*' | head -1)
        
        if [ ! -z "$CODE_SERVER_URL" ]; then
            echo "Code-Server Access:"
            echo "  URL: ${CODE_SERVER_URL}"
            echo "  Password: ${CODE_SERVER_PASSWORD}"
            echo ""
            echo "Open the URL in your web browser and enter the password to access code-server."
            echo ""
            echo "============================================"
            break
        fi
    fi
    sleep 2
done

if [ -z "$CODE_SERVER_URL" ]; then
    echo "Note: Ngrok tunnel is starting..."
    echo "Check the logs below for connection details"
    echo "============================================"
fi

echo ""
echo "Monitoring code-server and ngrok tunnel..."
echo "Press Ctrl+C to stop"
echo ""

# Keep the container running and monitor both code-server and ngrok
tail -f /tmp/ngrok.log &

# Monitor code-server process
while true; do
    if ! pgrep -f code-server > /dev/null; then
        echo "ERROR: code-server process has stopped!"
        exit 1
    fi
    sleep 10
done
