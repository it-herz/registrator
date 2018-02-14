#!/bin/bash
consul agent enable-script-checks advertise=$(POD_IP) bind=0.0.0.0 bootstrap-expect=3 retry-join=consul-0.consul.$(NAMESPACE).svc.cluster.local retry-join=consul-1.consul.$(NAMESPACE).svc.cluster.local retry-join=consul-2.consul.$(NAMESPACE).svc.cluster.local client=0.0.0.0 config-file=/consul/config/server.json datacenter=dc data-dir=/consul/data domain=herzen encrypt=$(GOSSIP_ENCRYPTION_KEY) server ui disable-host-node-id &
/bin/registrator

