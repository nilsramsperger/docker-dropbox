FROM debian:latest
RUN apt-get update \
    && apt-get install -y curl wget \
    && mkdir -p /opt/dropbox \
    && curl -Lo dropbox-linux-x86_64.tar.gz https://www.dropbox.com/download?plat=lnx.x86_64 \
    && tar xzfv dropbox-linux-x86_64.tar.gz --strip 1 -C /opt/dropbox \
    && rm dropbox-linux-x86_64.tar.gz
ADD ./files/supervisor.sh /
RUN chmod +x /supervisor.sh
VOLUME /root/.dropbox
ENTRYPOINT ["/supervisor.sh"]