#!/usr/bin/dumb-init /bin/sh
echo "Starting agent"
mkdir -p /etc/consul
echo "{\"encrypt\": \"$(echo -n $GOSSIP_ENCRYPTION_KEY | base64)\"}" > /etc/consul/encrypt.json
GOSSIP_KEY="-config-file /etc/consul/encrypt.json"
/usr/local/bin/docker-entrypoint.sh agent -enable-script-checks -advertise=$POD_IP -bind=0.0.0.0 -retry-join=consul-consul-0.consul-consul.$NAMESPACE.svc.cluster.local -retry-join=consul-consul-1.consul-consul.$NAMESPACE.svc.cluster.local -retry-join=consul-consul-2.consul-consul.$NAMESPACE.svc.cluster.local -client=0.0.0.0 -datacenter=$DC -data-dir=/consul/data -domain=$DOMAIN $GOSSIP_KEY &
echo "Starting registrator"
declare -i c
c=0
while [ $c -lt 30 ]
do
  /bin/registrator -cleanup=true -resync=10 -ttl-refresh=60 -ttl=120 -internal -useIpFromEnv=POD_IP consul://localhost:8500
  sleep 1
  c+=1
done
echo "Error in initialization"
