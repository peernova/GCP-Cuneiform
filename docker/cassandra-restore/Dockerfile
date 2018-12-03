FROM centos:7 

COPY cassandra-[0-9]* /tmp/

RUN mkdir /data

# assuming cassandra data will be mounted on /data;
# at this point, we need to copy the data the volume.
#CMD cd /data && [ -d /data/data/cuneiform_events2/ ] || tar xvzf /tmp/data.tgz && tar xvzf /tmp/commit.tgz && touch /data/data/cuneiform_events2/xxx && ls -lR /data
CMD cat /tmp/cassandra-* >>  /tmp/cassandra.tgz &&  cd /data  &&  [ -d /data/data/cuneiform_events/ ] || tar xvzf /tmp/cassandra.tgz  && touch /data/data/cuneiform_events2/xxx && ls -lR /data
