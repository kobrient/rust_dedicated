FROM cm2network/steamcmd:root

WORKDIR /home/steam/

EXPOSE 28015/udp
EXPOSE 28016/udp
EXPOSE 28016/tcp

VOLUME "./rust-data:/home/steam/rust/"
VOLUME "./rust-scripts:/home/steam/rust-scripts/"

CMD ["/home/steam/rust-scripts/runserver.sh"]
