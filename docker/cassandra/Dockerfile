FROM gcr.io/peernova-public-project/cuneiform-release:cassandra-3.11
USER root
RUN sed -i 's/ -Dcassandra.initial_token=0//g'  /usr/local/bin/cassandra-config
USER cassandra
