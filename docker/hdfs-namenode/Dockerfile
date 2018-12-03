FROM gcr.io/k8sinitialtests/cuneiform-release:hdfs-namenode-2.7.3
RUN sed -i 's/hdfs.service.consul/0.0.0.0/g' /usr/local/hadoop/etc/hadoop/core-site.xml
RUN apt-get update -y && apt-get install -y net-tools dnsutils
CMD if [ ! -z "$NAME_PREFIX" ]; then NAME_PREFIX="$NAME_PREFIX-" ; fi  && \
    sed -i  "s/\([0-9a-zA-Z\-]*\)\.service.consul/${NAME_PREFIX}\1/g" /usr/local/hadoop/etc/hadoop/*  && \
    sed -i "s/\.service\.consul//g; s/hdfs-datanode/${NAME_PREFIX}hdfs-datanode/g" /usr/local/hadoop/sbin/start-hdfs-namenode.sh && \
    cat  /usr/local/hadoop/etc/hadoop/yarn-site.xml  /usr/local/hadoop/sbin/start-hdfs-namenode.sh &&  \
    env &&  \
    $HADOOP_PREFIX/sbin/start-hdfs-namenode.sh
