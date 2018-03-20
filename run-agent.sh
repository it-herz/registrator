#!/usr/bin/dumb-init /bin/sh
echo "Starting agent"
/usr/local/bin/docker-entrypoint.sh agent -enable-script-checks -advertise=$POD_IP -bind=0.0.0.0 -retry-join=consul-consul-0.consul.$NAMESPACE.svc.cluster.local -retry-join=consul-consul-1.consul.$NAMESPACE.svc.cluster.local -retry-join=consul-consul-2.consul.$NAMESPACE.svc.cluster.local -client=0.0.0.0 -datacenter=$DC -data-dir=/consul/data -domain=$DOMAIN -encrypt=$GOSSIP_ENCRYPTION_KEY
echo "Starting registrator"
/bin/registrator -cleanup=true -resync=10 -ttl-refresh=60 -ttl=120 -internal -useIpFromEnv=POD_IP consul://localhost:8500
