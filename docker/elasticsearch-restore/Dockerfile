FROM centos:7 

COPY nodes-0* /tmp/
RUN mkdir /data

# assuming cassandra data will be mounted on /data;
# at this point, we need to copy the data the volume.
CMD cat /tmp/nodes-* >> /tmp/nodes.tgz && cd /data && [ -d /data/nodes/ ] ||  tar xvzf /tmp/nodes.tgz && ls -lR /data
