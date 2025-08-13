source "$(dirname "$0")/.env"

docker network create -d macvlan \
  --subnet=$SUBNET \
  --gateway=$GATEWAY \
  -o parent=$PARENT \
  local_net_macvlan