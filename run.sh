export DEBIAN_FRONTEND=noninteractive

export LOG=/var/log/jitsi/jvb.log

if [ ! -f "$LOG" ]; then
	
	sed 's/#\ create\(.*\)/echo\ create\1 $JICOFO_AUTH_USER $JICOFO_AUTH_DOMAIN $JICOFO_AUTH_PASSWORD/' -i /var/lib/dpkg/info/jitsi-meet-prosody.postinst

	echo 'jitsi-videobridge jitsi-videobridge/jvb-hostname string '"$JITSI_HOSTNAME" | debconf-set-selections
	dpkg-reconfigure jitsi-videobridge
	rm /etc/jitsi/jicofo/config && dpkg-reconfigure jicofo
	/var/lib/dpkg/info/jitsi-meet-prosody.postinst configure
	echo 'jitsi-meet jitsi-meet/cert-choice	select Self-signed certificate will be generated' | debconf-set-selections
	dpkg-reconfigure jitsi-meet

	touch $LOG && \
	chown jvb:jitsi $LOG
fi

rm /etc/nginx/sites-enabled/default

cd /etc/init.d/

./prosody restart && \
./jitsi-videobridge restart && \
./jicofo restart && \
./nginx restart

tail -f $LOG
