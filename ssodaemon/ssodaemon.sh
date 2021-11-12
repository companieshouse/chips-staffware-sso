#!/bin/bash

timestamp() {
  while read LINE
  do
    echo "$(date) ${LINE}"
  done
}

export CLASSPATH=/sso:/sso/libs/ssoRMI.jar:/sso/libs/wlthint3client.jar
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/sso/libs

VMARGS="-Dname=SSOServerFactory -Djava.security.policy=/sso/ssodaemon.policy -Xms128m -Xmx256m -classpath $CLASSPATH"
ARGS="-name=ssoServerFactory -protocol=JRMP -verbose"
CLASS=com.staffware.sso.rmi.rsServerFactoryImpl

# Set the vars in the jndi.properties file
envsubst < jndi.properties.template > jndi.properties

# Compile the Watcher class
/usr/java/jdk-8/bin/javac Watcher.java 

LOGS_DIR=/sso/logs/ssodaemon
mkdir -p ${LOGS_DIR}
LOG_FILE="${LOGS_DIR}/${HOSTNAME}-ssodaemon-$(date +'%Y-%m-%d_%H-%M-%S').log"

while :
do
  # Launch watcher process
  /sso/watcher.sh &

  # Attempt to bind the SSOServerFactory
  /usr/java/jdk-8/bin/java -d64 $VMARGS $CLASS $ARGS  

  echo "========================="
  echo "SSO Server Factory Exited >>>  on ${HOST_SERVER} "
  echo "========================="

  sleep 30
done 2>&1 | timestamp >> ${LOG_FILE}

