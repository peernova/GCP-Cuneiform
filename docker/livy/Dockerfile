FROM gcr.io/k8sinitialtests/cuneiform-release:livy-0.4
CMD if [ ! -z "$NAME_PREFIX" ]; then NAME_PREFIX="$NAME_PREFIX-" ; fi  && \
    echo sed -i  "s/\([a-zA-Z\-]*\)\.service.consul/${NAME_PREFIX}\1/g" /usr/local/hadoop/etc/hadoop/* /apps/livy-0.4.0-incubating-bin/conf/livy.conf && \
    sed -i  "s/\([0-9a-zA-Z\-]*\)\.service.consul/${NAME_PREFIX}\1/g" /usr/local/hadoop/etc/hadoop/* /apps/livy-0.4.0-incubating-bin/conf/livy.conf && \
    cat  /usr/local/hadoop/etc/hadoop/yarn-site.xml /apps/livy-0.4.0-incubating-bin/conf/livy.conf &&  \
    /apps/livy/conf/start-livy.sh
