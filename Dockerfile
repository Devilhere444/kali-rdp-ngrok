FROM fedora:43

# Update and install required packages
RUN dnf install -y --setopt=sslverify=false ca-certificates && \
    update-ca-trust && \
    dnf update -y --setopt=sslverify=false && \
    dnf install -y --setopt=sslverify=false \
        curl \
        git \
        nodejs \
        npm \
        && \
    dnf clean all

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install ngrok
RUN curl -fsSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -o /tmp/ngrok.tgz && \
    tar -xzf /tmp/ngrok.tgz -C /usr/local/bin && \
    chmod +x /usr/local/bin/ngrok && \
    rm /tmp/ngrok.tgz || \
    (echo "Warning: ngrok installation failed during build, will install at runtime" && true)

# Copy startup script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 8080

CMD ["/usr/local/bin/start.sh"]
