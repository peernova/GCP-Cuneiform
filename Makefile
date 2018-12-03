include ../vendor/marketplace-tools/app.Makefile
include ../vendor/marketplace-tools/crd.Makefile
include ../vendor/marketplace-tools/gcloud.Makefile
include ../vendor/marketplace-tools/marketplace.Makefile
include ../vendor/marketplace-tools/ubbagent.Makefile
include ../vendor/marketplace-tools/var.Makefile


TAG ?= 3.0.1
$(info ---- TAG = $(TAG))

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/cuneiform/deployer:$(TAG)
NAME ?= cuneiform-1
APP_PARAMETERS ?= { \
  "APP_INSTANCE_NAME": "$(NAME)", \
  "NAMESPACE": "$(NAMESPACE)" \
}
APP_TEST_PARAMETERS ?= {}


app/build:: .build/cuneiform/deployer \
            .build/cuneiform/cuneiform \
            .build/cuneiform/counterparty \
    	    .build/cuneiform/hdfs-datanode-2.7.3 \
            .build/cuneiform/hdfs-namenode-2.7.3 \
            .build/cuneiform/jobengine \
            .build/cuneiform/livy-0.4 \
            .build/cuneiform/rest-producer \
            .build/cuneiform/spark-dashboard \
            .build/cuneiform/yarn-rm-2.7.3 \
            .build/cuneiform/yarn-nm-2.7.3 \
            .build/cuneiform/elasticsearch-5.6.9 \
            .build/cuneiform/elasticsearch-restore \
            .build/cuneiform/kafka-0.10.2 \
            .build/cuneiform/nsq-lookup \
            .build/cuneiform/nsq \
            .build/cuneiform/zookeeper-3.4.11 \
            .build/cuneiform/consul-1.1.0 \
            .build/cuneiform/cassandra-3.11 \
            .build/cuneiform/cassandra-restore \
            .build/cuneiform/dbsetup  \
            .build/cuneiform/pn-docs  \
            .build/cuneiform/fe-caddy  \
            .build/cuneiform/fe-platform  \
            .build/cuneiform/mw-anchor  \
            .build/cuneiform/mw-analytics  \
            .build/cuneiform/mw-lineage  \
            .build/cuneiform/mw-search  


.build/cuneiform: | .build
	mkdir -p "$@"


.build/cuneiform/deployer: deployer/* \
                           manifest/* \
                           schema.yaml \
                           .build/var/APP_DEPLOYER_IMAGE \
                           .build/var/REGISTRY \
                           .build/var/TAG \
                           | .build/cuneiform
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)/cuneiform" \
	    --build-arg TAG="$(TAG)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


.build/cuneiform/cuneiform: .build/var/REGISTRY \
                            .build/var/TAG \
                            | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:cuneiform
	docker tag gcr.io/peernova-public-project/cuneiform-release:cuneiform \
	    "$(REGISTRY)/cuneiform:$(TAG)"
	docker push "$(REGISTRY)/cuneiform:$(TAG)"
	@touch "$@"


.build/cuneiform/counterparty: .build/var/REGISTRY \
                               .build/var/TAG \
                               | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:counterparty 
	docker tag gcr.io/peernova-public-project/cuneiform-release:counterparty \
	    "$(REGISTRY)/cuneiform/counterparty:$(TAG)" 
	docker push "$(REGISTRY)/cuneiform/counterparty:$(TAG)"
	@touch "$@"

.build/cuneiform/hdfs-datanode-2.7.3: .build/var/REGISTRY \
                                      .build/var/TAG \
                                      | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:hdfs-datanode-2.7.3
	docker tag gcr.io/peernova-public-project/cuneiform-release:hdfs-datanode-2.7.3 \
	    "$(REGISTRY)/cuneiform/hdfs-datanode-2.7.3:$(TAG)" 
	docker push "$(REGISTRY)/cuneiform/hdfs-datanode-2.7.3:$(TAG)"
	@touch "$@"

.build/cuneiform/hdfs-namenode-2.7.3: .build/var/REGISTRY \
                                      .build/var/TAG \
                                      | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:hdfs-namenode-2.7.3
	docker tag gcr.io/peernova-public-project/cuneiform-release:hdfs-namenode-2.7.3 \
	    "$(REGISTRY)/cuneiform/hdfs-namenode-2.7.3:$(TAG)" 
	docker push "$(REGISTRY)/cuneiform/hdfs-namenode-2.7.3:$(TAG)"
	@touch "$@"

.build/cuneiform/jobengine: .build/var/REGISTRY \
                                 .build/var/TAG \
                               | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:jobengine
	docker tag gcr.io/peernova-public-project/cuneiform-release:jobengine \
	    "$(REGISTRY)/cuneiform/jobengine:$(TAG)" 
	docker push "$(REGISTRY)/cuneiform/jobengine:$(TAG)"
	@touch "$@"

.build/cuneiform/livy-0.4: .build/var/REGISTRY \
                           .build/var/TAG \
                           | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:livy-0.4
	docker tag gcr.io/peernova-public-project/cuneiform-release:livy-0.4 \
	    "$(REGISTRY)/cuneiform/livy-0.4:$(TAG)" 
	docker push "$(REGISTRY)/cuneiform/livy-0.4:$(TAG)"
	@touch "$@"

.build/cuneiform/rest-producer: .build/var/REGISTRY \
                                .build/var/TAG \
                                | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:rest-producer
	docker tag gcr.io/peernova-public-project/cuneiform-release:rest-producer \
	    "$(REGISTRY)/cuneiform/rest-producer:$(TAG)" 
	docker push "$(REGISTRY)/cuneiform/rest-producer:$(TAG)"
	@touch "$@"

.build/cuneiform/spark-dashboard: .build/var/REGISTRY \
                                  .build/var/TAG \
                                | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:spark-dashboard
	docker tag gcr.io/peernova-public-project/cuneiform-release:spark-dashboard \
	    "$(REGISTRY)/cuneiform/spark-dashboard:$(TAG)" 
	docker push "$(REGISTRY)/cuneiform/spark-dashboard:$(TAG)"
	@touch "$@"

.build/cuneiform/yarn-rm-2.7.3: .build/var/REGISTRY \
                                .build/var/TAG \
                                | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:yarn-rm-2.7.3
	docker tag gcr.io/peernova-public-project/cuneiform-release:yarn-rm-2.7.3 \
	    "$(REGISTRY)/cuneiform/yarn-rm-2.7.3:$(TAG)" 
	docker push "$(REGISTRY)/cuneiform/yarn-rm-2.7.3:$(TAG)"
	@touch "$@"

.build/cuneiform/yarn-nm-2.7.3: .build/var/REGISTRY \
                                .build/var/TAG \
                                | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:yarn-nm-2.7.3
	docker tag gcr.io/peernova-public-project/cuneiform-release:yarn-nm-2.7.3 \
	    "$(REGISTRY)/cuneiform/yarn-nm-2.7.3:$(TAG)" 
	docker push "$(REGISTRY)/cuneiform/yarn-nm-2.7.3:$(TAG)"
	@touch "$@"

.build/cuneiform/elasticsearch-5.6.9: .build/var/REGISTRY \
                                          .build/var/TAG \
                                          | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:elasticsearch-5.6.9
	docker tag gcr.io/peernova-public-project/cuneiform-release:elasticsearch-5.6.9 \
	    "$(REGISTRY)/cuneiform/elasticsearch-5.6.9:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/elasticsearch-5.6.9:$(TAG)"
	@touch "$@"

.build/cuneiform/elasticsearch-restore: .build/var/REGISTRY \
                                        .build/var/TAG \
                                        | .build/cuneiform
	docker build -f docker/elasticsearch-restore/Dockerfile -t "$(REGISTRY)/cuneiform/elasticsearch-restore:$(TAG)" docker/elasticsearch-restore
	docker push "$(REGISTRY)/cuneiform/elasticsearch-restore:$(TAG)"
	@touch "$@"


.build/cuneiform/kafka-0.10.2: .build/var/REGISTRY \
                               .build/var/TAG \
                               | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:kafka-0.10.2
	docker tag gcr.io/peernova-public-project/cuneiform-release:kafka-0.10.2 \
	    "$(REGISTRY)/cuneiform/kafka-0.10.2:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/kafka-0.10.2:$(TAG)"
	@touch "$@"


.build/cuneiform/nsq-lookup: .build/var/REGISTRY \
                             .build/var/TAG \
                             | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:nsq-lookup
	docker tag gcr.io/peernova-public-project/cuneiform-release:nsq-lookup \
	    "$(REGISTRY)/cuneiform/nsq-lookup:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/nsq-lookup:$(TAG)"
	@touch "$@"

.build/cuneiform/nsq: .build/var/REGISTRY \
                      .build/var/TAG \
                      | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:nsq
	docker tag gcr.io/peernova-public-project/cuneiform-release:nsq \
	    "$(REGISTRY)/cuneiform/nsq:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/nsq:$(TAG)"
	@touch "$@"

.build/cuneiform/zookeeper-3.4.11: .build/var/REGISTRY \
                                  .build/var/TAG \
                                  | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:zookeeper-3.4.11
	docker tag gcr.io/peernova-public-project/cuneiform-release:zookeeper-3.4.11 \
	    "$(REGISTRY)/cuneiform/zookeeper-3.4.11:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/zookeeper-3.4.11:$(TAG)"
	@touch "$@"

.build/cuneiform/consul-1.1.0: .build/var/REGISTRY \
                               .build/var/TAG \
                               | .build/cuneiform
	docker build -f docker/consul/Dockerfile -t "$(REGISTRY)/cuneiform/consul-1.1.0:$(TAG)" docker/consul
	docker push "$(REGISTRY)/cuneiform/consul-1.1.0:$(TAG)"
	@touch "$@"

.build/cuneiform/cassandra-3.11: .build/var/REGISTRY \
                                 .build/var/TAG \
                                 | .build/cuneiform
	docker pull gcr.io/peernova-public-project/cuneiform-release:cassandra-3.11
	docker build -f docker/cassandra/Dockerfile -t "$(REGISTRY)/cuneiform/cassandra-3.11:$(TAG)" docker/cassandra
	docker push "$(REGISTRY)/cuneiform/cassandra-3.11:$(TAG)"
	@touch "$@"

.build/cuneiform/cassandra-restore: .build/var/REGISTRY \
                                    .build/var/TAG \
                                    | .build/cuneiform
	docker build -f docker/cassandra-restore/Dockerfile -t "$(REGISTRY)/cuneiform/cassandra-restore:$(TAG)" docker/cassandra-restore
	docker push "$(REGISTRY)/cuneiform/cassandra-restore:$(TAG)"
	@touch "$@"


.build/cuneiform/dbsetup: .build/var/REGISTRY \
                          .build/var/TAG \
                          | .build/cuneiform
	docker build -f docker/dbsetup/Dockerfile -t "$(REGISTRY)/cuneiform/dbsetup:$(TAG)" docker/dbsetup
	docker push "$(REGISTRY)/cuneiform/dbsetup:$(TAG)"
	@touch "$@"

.build/cuneiform/pn-docs: .build/var/REGISTRY \
                           .build/var/TAG \
                           | .build/cuneiform
	docker pull gcr.io/peernova-public-project/jenkins-ci:pn-docs-u18-master-unstable
	docker tag gcr.io/peernova-public-project/jenkins-ci:pn-docs-u18-master-unstable \
	    "$(REGISTRY)/cuneiform/pn-docs:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/pn-docs:$(TAG)"
	@touch "$@"


.build/cuneiform/fe-caddy: .build/var/REGISTRY \
                           .build/var/TAG \
                           | .build/cuneiform
	docker pull gcr.io/peernova-public-project/jenkins-ci:fe-caddy-el7-GCP-Master-unstable
	docker tag gcr.io/peernova-public-project/jenkins-ci:fe-caddy-el7-GCP-Master-unstable \
	    "$(REGISTRY)/cuneiform/fe-caddy:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/fe-caddy:$(TAG)"
	@touch "$@"


.build/cuneiform/fe-platform: .build/var/REGISTRY \
                              .build/var/TAG \
                              | .build/cuneiform
	docker pull gcr.io/peernova-public-project/jenkins-ci:fe-platform-el7-GCP-Master-unstable
	docker tag gcr.io/peernova-public-project/jenkins-ci:fe-platform-el7-GCP-Master-unstable \
	    "$(REGISTRY)/cuneiform/fe-platform:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/fe-platform:$(TAG)"
	@touch "$@"


.build/cuneiform/mw-anchor: .build/var/REGISTRY \
                            .build/var/TAG \
                            | .build/cuneiform
	docker pull gcr.io/peernova-public-project/jenkins-ci:mw-anchor-el7-GCP-Master-unstable
	docker tag gcr.io/peernova-public-project/jenkins-ci:mw-anchor-el7-GCP-Master-unstable \
	    "$(REGISTRY)/cuneiform/mw-anchor:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/mw-anchor:$(TAG)"
	@touch "$@"


.build/cuneiform/mw-analytics: .build/var/REGISTRY \
                            .build/var/TAG \
                            | .build/cuneiform
	docker pull gcr.io/peernova-public-project/jenkins-ci:mw-analytics-el7-GCP-Master-unstable
	docker tag gcr.io/peernova-public-project/jenkins-ci:mw-analytics-el7-GCP-Master-unstable \
	    "$(REGISTRY)/cuneiform/mw-analytics:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/mw-analytics:$(TAG)"
	@touch "$@"


.build/cuneiform/mw-lineage: .build/var/REGISTRY \
                             .build/var/TAG \
                             | .build/cuneiform
	docker pull gcr.io/peernova-public-project/jenkins-ci:mw-lineage-el7-GCP-Master-unstable
	docker tag gcr.io/peernova-public-project/jenkins-ci:mw-lineage-el7-GCP-Master-unstable \
	    "$(REGISTRY)/cuneiform/mw-lineage:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/mw-lineage:$(TAG)"
	@touch "$@"


.build/cuneiform/mw-search: .build/var/REGISTRY \
                            .build/var/TAG \
                            | .build/cuneiform
	docker pull gcr.io/peernova-public-project/jenkins-ci:mw-search-el7-GCP-Master-unstable
	docker tag gcr.io/peernova-public-project/jenkins-ci:mw-search-el7-GCP-Master-unstable \
	    "$(REGISTRY)/cuneiform/mw-search:$(TAG)"
	docker push "$(REGISTRY)/cuneiform/mw-search:$(TAG)"
	@touch "$@"


