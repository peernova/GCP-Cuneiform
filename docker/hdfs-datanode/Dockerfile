FROM gcr.io/k8sinitialtests/cuneiform-release:hdfs-datanode-2.7.3
#RUN sed -i  's/\.service\.consul//g'  /usr/local/hadoop/etc/hadoop/*
CMD if [ ! -z "$NAME_PREFIX" ]; then NAME_PREFIX="$NAME_PREFIX-" ; fi  && \
    sed -i  "s/\([0-9a-zA-Z\-]*\)\.service.consul/${NAME_PREFIX}\1/g" /usr/local/hadoop/etc/hadoop/*  && \
    cat  /usr/local/hadoop/etc/hadoop/yarn-site.xml &&  \
    env &&  \
    $HADOOP_PREFIX/sbin/start-hdfs-datanode.sh
