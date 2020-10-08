

#rm -f /tmp/hosts
#
#for i in *.json ; do
#  COMPONENT=$(echo $i | sed -e 's/.json//')
#  IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
#  echo $IP component=$COMPONENT >>/tmp/hosts
#  sed -e "s/IPADDRESS/${IP}/" -e "s/DNS_NAME/${COMPONENT}/" record.json >/tmp/record.json
#  aws route53 change-resource-record.json-sets --hosted-zone-id Z000052511SHFQ7DL9WLG --change-batch file:///tmp/record.json
#done
#Invalid choice: 'change-resource-record.json-sets', maybe you meant:



#!/bin/bash

rm -f /tmp/hosts

for i in *.json ; do
  COMPONENT=$(echo $i | sed -e 's/.json//')
  IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
  if [ -z "${IP}" ]; then
    continue
  fi
  echo $IP component=$COMPONENT >>/tmp/hosts
  sed -e "s/IPADDRESS/${IP}/" -e "s/DNS_NAME/${COMPONENT}/" record >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id Z000052511SHFQ7DL9WLG --change-batch file:///tmp/record.json
done

