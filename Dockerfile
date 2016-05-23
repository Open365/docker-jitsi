FROM debian:latest
MAINTAINER Roberto Andrade <roberto@cloud.com>
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV JITSI_HOSTNAME test.eyeos.com
ENV WHATAMI jitsi

RUN apt-get update && \
	apt-get install -y wget dnsutils vim telnet && \
	echo 'deb http://download.jitsi.org/nightly/deb unstable/' >> /etc/apt/sources.list && \
	wget -qO - https://download.jitsi.org/nightly/deb/unstable/archive.key | apt-key add - && \
	apt-get update

RUN \
	apt-get -y install jitsi-meet \
	        build-essential \
	        git \
	        curl \
	        unzip

RUN \
	curl -sL https://deb.nodesource.com/setup | bash - && \
	apt-get -y install nodejs

RUN \
	apt-get clean && \
	curl -L https://releases.hashicorp.com/serf/0.6.4/serf_0.6.4_linux_amd64.zip -o serf.zip && \
    	unzip serf.zip && \
    	mv serf /usr/bin/serf && \
    	rm serf.zip && \
    	npm install -g \
    		eyeos-run-server \
    		eyeos-service-ready-notify-cli \
    		eyeos-tags-to-dns

#ENV PUBLIC_HOSTNAME=192.168.59.103

#/etc/jitsi/meet/localhost-config.js = bosh: '//localhost/http-bind',
#RUN sed s/JVB_HOSTNAME=/JVB_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/videobridge/config && \
#	sed s/JICOFO_HOSTNAME=/JICOFO_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/jicofo/config

#EXPOSE 80 443 5347 4453
#EXPOSE 5347 4453
#EXPOSE 10000/udp 10001/udp 10002/udp 10003/udp 10004/udp 10005/udp 10006/udp 10007/udp 10008/udp 10009/udp 10010/udp

COPY run.sh /run.sh
COPY index.html /usr/share/jitsi-meet/index.html
COPY test.eyeos.com.conf /etc/nginx/sites-enabled/test.eyeos.com.conf
CMD /run.sh
COPY config.js /etc/jitsi/meet/test.eyeos.com-config.js
COPY app.bundle.min.js /usr/share/jitsi-meet/libs/app.bundle.min.js
