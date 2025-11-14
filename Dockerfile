FROM kalilinux/kali-rolling

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        xfce4 xfce4-goodies xrdp dbus-x11 sudo curl unzip && \
    echo "root:Devil" | chpasswd && \
    adduser xrdp ssl-cert

# Configure XRDP to prevent blue screen
RUN echo "xfce4-session" > /root/.xsession && \
    chmod +x /root/.xsession && \
    echo "#!/bin/sh" > /etc/xrdp/startwm.sh && \
    echo "unset DBUS_SESSION_BUS_ADDRESS" >> /etc/xrdp/startwm.sh && \
    echo "unset XDG_RUNTIME_DIR" >> /etc/xrdp/startwm.sh && \
    echo "if [ -r /etc/default/locale ]; then" >> /etc/xrdp/startwm.sh && \
    echo "  . /etc/default/locale" >> /etc/xrdp/startwm.sh && \
    echo "  export LANG LANGUAGE" >> /etc/xrdp/startwm.sh && \
    echo "fi" >> /etc/xrdp/startwm.sh && \
    echo "startxfce4" >> /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

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
