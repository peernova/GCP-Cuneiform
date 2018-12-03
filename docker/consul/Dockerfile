FROM centos:7 

RUN yum install -y unzip
RUN mkdir -p /var/lib/consul /etc/consul
COPY conf/* /etc/consul/

ADD https://releases.hashicorp.com/consul/1.1.0/consul_1.1.0_linux_amd64.zip /usr/bin/

RUN cd /usr/bin/ && unzip consul_1.1.0_linux_amd64.zip && rm -f consul_1.1.0_linux_amd64.zip

# start
CMD  if [ ! -z "$NAME_PREFIX" ]; then NAME_PREFIX="$NAME_PREFIX-" ; fi  && \ 
     echo "{ \"retry_join\": [ \"${NAME_PREFIX}consul\" ] }" > /etc/consul/connect.json && \
     /usr/bin/consul agent -ui -config-file=/etc/consul/consul.json -config-dir=/etc/consul
