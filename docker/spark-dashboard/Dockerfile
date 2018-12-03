FROM gcr.io/k8sinitialtests/cuneiform-release:spark-dashboard

CMD if [ ! -z "$NAME_PREFIX" ]; then NAME_PREFIX="$NAME_PREFIX-" ; fi  && \
    sed -i  "s/\([0-9a-zA-Z\-]*\)\.service.consul/${NAME_PREFIX}\1/g" /peernova/workarea/bin/src/main/resources/application.conf  && \
    cat  /peernova/workarea/bin/src/main/resources/application.conf && \ 
    java -Dconfig.file=/peernova/workarea/bin/src/main/resources/application.conf -jar /peernova/workarea/bin/dashboard.jar port=4080 host=0.0.0.0


