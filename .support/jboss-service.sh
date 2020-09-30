#!/bin/sh
### BEGIN INIT INFO
# Reference: http://stackoverflow.com/questions/6880902/start-jboss-7-as-a-service-on-linux
# Provides:          jboss
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/Stop JBoss AS v7.0.0
### END INIT INFO
#
#source some script files in order to set and export environmental variables
#as well as add the appropriate executables to $PATH
#[ -r /etc/profile.d/java.sh ] && . /etc/profile.d/java.sh
#[ -r /etc/profile.d/jboss.sh ] && . /etc/profile.d/jboss.sh

AS7_OPTS="$AS7_OPTS -Dorg.apache.tomcat.util.http.ServerCookie.ALLOW_HTTP_SEPARATORS_IN_V0=true"   ## See AS7-1625
AS7_OPTS="$AS7_OPTS -Djboss.bind.address.management=0.0.0.0"
AS7_OPTS="$AS7_OPTS -Djboss.bind.address=0.0.0.0"
AS7_OPTS="$AS7_OPTS -Djboss.socket.binding.port-offset=777"
AS7_OPTS="$AS7_OPTS -Dcom.sun.management.jmxremote"
AS7_OPTS="$AS7_OPTS -Dcom.sun.management.jmxremote.port=7007"
AS7_OPTS="$AS7_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
AS7_OPTS="$AS7_OPTS -Dcom.sun.management.jmxremote.ssl=false"


export JBOSS_HOME=/opt/jboss/jboss-eap-7.2
case "$1" in
    start)
        echo "Starting JBoss AS 7.2"
	#su - jboss -c "source /home/jboss/EAP-7.2.ENV;${JBOSS_HOME}/bin/standalone.sh -c standalone-full.xml $AS7_OPTS > /dev/null 2>&1 &"
        su - jboss -c "${JBOSS_HOME}/bin/standalone.sh -c standalone-full.xml $AS7_OPTS > /dev/null 2>&1 &"
    ;;
    stop)
        echo "Stopping JBoss AS 7.2"
        su - jboss -c "${JBOSS_HOME}/bin/jboss-cli.sh --controller=192.168.200.102:10767 --connect --command=:shutdown > /dev/null 2>&1 &"
    ;;
    *)
        echo "Usage: /etc/init.d/jboss {start|stop}"
        exit 1
    ;;
esac

exit 0
