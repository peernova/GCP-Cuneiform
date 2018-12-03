FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:v0.6.2

# Install Oracle Java8
ENV JAVA_VERSION 8u171
ENV JAVA_BUILD b11
ENV JAVA_DL_HASH 512cd62ec5174c3487ac17c61aaa89e8

RUN apt-get update -y  \
    && apt-get install -y software-properties-common gpg \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated  oracle-java8-installer \
    && apt-get install -y --no-install-recommends --allow-unauthenticated oracle-java8-set-default \
    && rm -rf /var/cache/oracle-jdk8-installer 

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/



RUN apt-get update -y && apt-get install -y curl unzip

ADD manifest/* /data/manifest/
ADD schema.yaml /data/

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG
RUN cat /data/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /data/schema.yaml.new \
    && mv /data/schema.yaml.new /data/schema.yaml


RUN mkdir /validator  
#COPY deployer/validator/ /validator/
COPY deployer/validator/validator.gz /validator/
COPY deployer/validator/ks /validator/
COPY deployer/validator/data.config /validator/
COPY deployer/validator/deploy_and_validate.sh /bin/deploy.sh
COPY deployer/validator/start-all.sh /bin/start-all.sh
COPY scripts/external_replace.sh /bin/external_replace.sh
RUN gunzip /validator/validator.gz && chmod +x /validator/validator

RUN mkdir /ingestor
COPY deployer/ingestor/ /ingestor/



#Hadoop Environment
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV HADOOP_OPTS -Djava.net.preferIPv4Stack=true
ENV HADOOP_HEAPSIZE 3096


#Install Hadoop 2.7.3 & Spark
RUN curl -s  https://s3-us-west-1.amazonaws.com/peernova-dataprocessing-repo/hadoop-2.7.3.tar.gz | tar -xz -C /usr/local/ \
    && cd /usr/local && ln -s ./hadoop-2.7.3 hadoop 


COPY deployer/hadoop/* $HADOOP_PREFIX/etc/hadoop/

# Remove lines below
#ENTRYPOINT []
#CMD echo starting && sleep infinity  && echo done
