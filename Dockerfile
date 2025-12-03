FROM 300288021642.dkr.ecr.eu-west-2.amazonaws.com/ch-serverjre:2.0.0 AS builder

ARG ARTIFACTORY_URL
ARG ARTIFACTORY_USERNAME
ARG ARTIFACTORY_PASSWORD

ENV SSO_HOME=/sso \
    ARTIFACTORY_BASE_URL=${ARTIFACTORY_URL}/virtual-release

# Add an sso user
RUN useradd -d ${SSO_HOME} -m -s /bin/bash sso

USER sso

# Copy over scripts and properties
COPY --chown=sso ssodaemon ${SSO_HOME}/

# Download the Staffware SSO libs and set permission on script
RUN mkdir -p ${SSO_HOME}/libs && \
    cd ${SSO_HOME}/libs && \
    curl -L -u "${ARTIFACTORY_USERNAME}:${ARTIFACTORY_PASSWORD}" ${ARTIFACTORY_BASE_URL}/com/staffware/libssoJNI/11.4.1/libssoJNI-11.4.1.so -o libssoJNI.so && \
    curl -L -u "${ARTIFACTORY_USERNAME}:${ARTIFACTORY_PASSWORD}" ${ARTIFACTORY_BASE_URL}/com/staffware/ssoRMI/11.4.1/ssoRMI-11.4.1.jar -o ssoRMI.jar && \
    curl -L -u "${ARTIFACTORY_USERNAME}:${ARTIFACTORY_PASSWORD}" ${ARTIFACTORY_BASE_URL}/com/oracle/weblogic/wlthint3client/14.1.2.0/wlthint3client-14.1.2.0.jar -o wlthint3client.jar && \
    cd && /usr/java/jdk/bin/javac Watcher.java && \
    chmod 500 *.sh

FROM 300288021642.dkr.ecr.eu-west-2.amazonaws.com/ch-serverjre:2.0.0

ENV SSO_HOME=/sso

RUN yum -y install gettext && \
    yum clean all && \
    rm -rf /var/cache/yum

# Add an sso user
RUN useradd -d ${SSO_HOME} -m -s /bin/bash sso

# Copy over the home directory from the builder
COPY --from=builder --chown=sso ${SSO_HOME} ${SSO_HOME}/

USER sso
WORKDIR ${SSO_HOME}

CMD ["bash"]
