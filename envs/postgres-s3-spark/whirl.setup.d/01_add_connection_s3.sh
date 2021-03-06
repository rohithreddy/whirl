#!/usr/bin/env bash

echo "=================="
echo "== Configure S3 =="
echo "=================="

pip install awscli awscli-plugin-endpoint

echo -e "$AWS_ACCESS_KEY_ID\n$AWS_SECRET_ACCESS_KEY\n\n" | aws configure
aws configure set plugins.endpoint awscli_plugin_endpoint
aws configure set default.s3.endpoint_url http://${AWS_SERVER}:${AWS_PORT}
aws configure set default.s3api.endpoint_url http://${AWS_SERVER}:${AWS_PORT}

echo "======================"
echo "== Create S3 Bucket =="
echo "======================"
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://${AWS_SERVER}:${PORT_WEB_UI})" != "200" ]]; do
  echo "Waiting for ${AWS_SERVER} to come up..."
  sleep 2;
done

echo "creating bucket"
S3_SERVER_IP=$(dig +short ${AWS_SERVER})
aws s3api create-bucket --bucket ${DEMO_BUCKET}
echo -e "${S3_SERVER_IP}\t${DEMO_BUCKET}.${AWS_SERVER}" >> /etc/hosts
