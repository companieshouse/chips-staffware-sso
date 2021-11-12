#!/bin/bash

# This scripts checks for the presence of a java SSOServerFactory process
# and checks that the ssoServerFactory object can be obtained from WebLogic
# 
# If there is no SSOServerFactory process, the script exits
# If there is a process, the script tries to connect to WebLogic using the Watcher java class
## If the reference to the ssoServerFactory can be obtained, the script waits and then repeats the check for the process etc
## If the reference to the ssoServerFactory can't be obtained, the script kills the SSOServerFactory process and exits
#
# Killing of the SSOServerFactory process will cause a new watcher instance to be created in the parent ssodaemon.sh script,
# and another attempt will be made to bind the ssoServerFactory to WebLogic

# Wait to give the parent process time to successfully bind to WebLogic
sleep 10

while :
do
  # Check for java SSOServerFactory process
  SSO_PID=$(ps -ef | grep SSOServerFactory | grep -v grep | awk '{print $2}')

  if [ ${SSO_PID}x == "x" ]; then
    echo "Watcher: no SSOServerFactory process found, so exiting.."
    exit 0
  fi

  /usr/java/jdk-8/bin/java -cp /sso:/sso/libs/wlthint3client.jar Watcher ssoServerFactory
  WATCHER_EXIT_CODE=$?

  if [ ${WATCHER_EXIT_CODE} -ne 0 ]; then
    echo "Watcher: failed to obtain reference so killing SSOServerFactory and exiting.."
    kill ${SSO_PID}
    exit 0
  fi

  echo "Watcher: reference obtained, so sleeping.."
  sleep 30
done

