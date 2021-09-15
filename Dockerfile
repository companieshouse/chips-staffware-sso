FROM 300288021642.dkr.ecr.eu-west-2.amazonaws.com/ch-serverjre:1.2.0

RUN yum -y install gettext && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV SSO_HOME=/sso \
    ARTIFACTORY_BASE_URL=http://repository.aws.chdev.org:8081/artifactory

# Add an sso user and home directory
RUN mkdir -p ${SSO_HOME} && \
    useradd -d ${SSO_HOME} -m -s /bin/bash sso && \
    chown sso ${SSO_HOME}

USER sso
WORKDIR ${SSO_HOME}

# Copy over scripts and properties
COPY --chown=sso ssodaemon ${SSO_HOME}/

# Download the Staffware SSO libs and set permission on script
RUN mkdir -p ${SSO_HOME}/libs && \
    cd ${SSO_HOME}/libs && \
    curl ${ARTIFACTORY_BASE_URL}/libs-release/com/staffware/libssoJNI/11.4.1/libssoJNI-11.4.1.so -o libssoJNI.so && \
    curl ${ARTIFACTORY_BASE_URL}/libs-release/com/staffware/ssoRMI/11.4.1/ssoRMI-11.4.1.jar -o ssoRMI.jar && \
    curl ${ARTIFACTORY_BASE_URL}/local-ch-release/com/oracle/weblogic/wlthint3client/12.2.1.4/wlthint3client-12.2.1.4.jar -o wlthint3client.jar && \
    chmod 750 ${SSO_HOME}/*.sh

CMD ["bash"]
