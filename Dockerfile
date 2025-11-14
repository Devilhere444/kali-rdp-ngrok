FROM kalilinux/kali-rolling

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        xfce4 xfce4-goodies xrdp dbus-x11 sudo curl unzip && \
    echo "root:root" | chpasswd && \
    adduser xrdp ssl-cert

# Install ngrok
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | gpg --dearmor -o /usr/share/keyrings/ngrok.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list && \
    apt update && apt install -y ngrok

# Copy ngrok config
COPY ngrok.yml /root/.ngrok2/ngrok.yml

EXPOSE 3389

CMD service dbus start && \
    service xrdp start && \
    ngrok start --all --config /root/.ngrok2/ngrok.yml & \
    tail -f /dev/null
