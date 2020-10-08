

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
#aws route53 change-resource-record-sets --hosted-zone-id <ZoneId> --change-batch '{\"Changes\": [{\"Action\": \"UPSERT\",\"ResourceRecordSet\": {\"Name\": \"dev.mydns.com\",\"Type\": \"CNAME\",\"TTL\": 300,\"ResourceRecords\": [{\"Value\": \"s-########1.server.transfer.us-east-1.amazonaws.com.\"}]}}]}'

{
  "Comment": "DNS Record",
  "Changes": [{
    "Action": "CREATE",
    "ResourceRecordSet": {
      "Name": "DNS_NAME.helodevops.tech",
      "Type": "A",
      "TTL": 300,
      "ResourceRecords": [{ "Value": "IPADDRESS"}]
    }}]
}



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

