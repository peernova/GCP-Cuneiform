FROM centos:7

COPY dbsetup /usr/local/bin
COPY *cql /tmp/
ENV CASSANDRA=cassandra.service.consul
CMD dbsetup run --cassandra.connection="cassandra://$CASSANDRA" --dbsetup.keyspace=cuneiform_events --dbsetup.datamodelfile=/tmp/canary.cql && \
    dbsetup run --cassandra.connection="cassandra://$CASSANDRA" --dbsetup.keyspace=cuneiform_events2 --dbsetup.datamodelfile=/tmp/canary.cql && \
    dbsetup run --cassandra.connection="cassandra://$CASSANDRA" --dbsetup.keyspace=cuneiform_events3 --dbsetup.datamodelfile=/tmp/canary.cql && \
    dbsetup run --cassandra.connection="cassandra://$CASSANDRA" --dbsetup.keyspace=lineage --dbsetup.datamodelfile=/tmp/lineage.cql && \ 
    sleep infinity
