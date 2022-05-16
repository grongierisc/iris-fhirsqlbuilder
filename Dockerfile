ARG IMAGE=store/intersystems/iris-community:2020.1.0.204.0
ARG IMAGE=intersystemsdc/iris-community:2020.1.0.209.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.2.0.204.0-zpm
ARG IMAGE=intersystemsdc/irishealth-community:2020.2.0.204.0-zpm
ARG IMAGE=arti.iscinternal.com/intersystems/irishealth:2022.1.0DEVIH.96.0
FROM $IMAGE

USER root

COPY key/iris.key /usr/irissys/mgr/iris.key

# Update package and install sudo
RUN apt-get update && apt-get install -y \
	git \
	nano \
	sudo && \
	/bin/echo -e ${ISC_PACKAGE_MGRUSER}\\tALL=\(ALL\)\\tNOPASSWD: ALL >> /etc/sudoers && \
	sudo -u ${ISC_PACKAGE_MGRUSER} sudo echo enabled passwordless sudo-ing for ${ISC_PACKAGE_MGRUSER}

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
USER ${ISC_PACKAGE_MGRUSER}

COPY  src src
COPY data/fhir fhirdata
COPY iris.script /tmp/iris.script
COPY fhirUI /usr/irissys/csp/user/fhirUI

# run iris and initial 
RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script
