ARG IMAGE=intersystemsdc/irishealth-community:latest
FROM $IMAGE 

WORKDIR /irisdev/app

## Python stuff
ENV IRISUSERNAME "SuperUser"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE "IRISAPP"

ENV PYTHON_PATH=/usr/irissys/bin/
ENV LD_LIBRARY_PATH=${ISC_PACKAGE_INSTALLDIR}/bin:${LD_LIBRARY_PATH}

ENV PATH "/home/irisowner/.local/bin:/usr/irissys/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/irisowner/bin"

COPY . .

RUN pip3 install -r requirements.txt
RUN pip3 install python_fhir_converter-0.4.4-py3-none-any.whl

COPY iris.script /tmp/iris.script

# run iris and initial 
RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
	&& iris stop IRIS quietly