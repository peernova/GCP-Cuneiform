FROM gcr.io/k8sinitialtests/cuneiform-release:jobengine
RUN mkdir -p /apps/peernova/jobs
COPY jobs/* /apps/peernova/jobs/
ENV DEFAULT_JOB_DIR /apps/peernova/jobs

CMD if [ ! -z "$NAME_PREFIX" ]; then NAME_PREFIX="$NAME_PREFIX-" ; fi  && \
    sed -i  "s/\([0-9a-zA-Z\-]*\)\.service.consul/${NAME_PREFIX}\1/g" /usr/local/hadoop/etc/hadoop/*  && \
    cat  /usr/local/hadoop/etc/hadoop/slaves &&  \
    java -cp $JOBENGINE_HOME/jobengine.jar:$SPARK_HOME/jars/* com.peernova.jobgateway.JobGateway host=0.0.0.0 port=4599 | tee jobengine.log 2>&1
