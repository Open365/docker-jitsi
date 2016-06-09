FROM debian:jessie
MAINTAINER eyeos
ENV DEBIAN_FRONTEND noninteractive
ENV JITSI_HOSTNAME test.eyeos.com
ENV WHATAMI jitsi

RUN apt-get update && \
	apt-get install -y --no-install-recommends wget ca-certificates apt-transport-https && \
	echo 'deb http://download.jitsi.org/nightly/deb unstable/' >> /etc/apt/sources.list && \
	wget -O - http://download.jitsi.org/nightly/deb/unstable/archive.key | apt-key add - && \
	echo 'deb https://deb.nodesource.com/node_6.x jessie main' >> /etc/apt/sources.list && \
	wget -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
	apt-get update && \
	apt-get -y install --no-install-recommends nodejs jitsi-meet build-essential python git unzip dnsmasq && \
	wget https://releases.hashicorp.com/serf/0.6.4/serf_0.6.4_linux_amd64.zip -qO serf.zip && \
	unzip serf.zip && mv serf /usr/bin/serf && rm serf.zip && \
	npm install -g eyeos-run-server eyeos-service-ready-notify-cli eyeos-tags-to-dns && \
	apt-get remove -y wget build-essential git unzip npm python && \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -r /var/lib/apt/lists/* && rm -r /root/.npm && rm -r /tmp && rm -r /var/tmp

COPY run.sh /run.sh
COPY index.html /usr/share/jitsi-meet/index.html
COPY test.eyeos.com.conf /tmp/test.eyeos.com.conf
COPY config.js /tmp/test.eyeos.com-config.js
COPY app.bundle.min.js /usr/share/jitsi-meet/libs/app.bundle.min.js
COPY dnsmasq.conf /etc/dnsmasq.d/

CMD eyeos-run-server --serf /run.sh
