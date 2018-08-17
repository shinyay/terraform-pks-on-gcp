#!/usr/bin/env fish

set -x MASTER_EXTERNAL_IP (gcloud compute addresses describe $CLUSTER_NAME-master-api-ip --region $GCP_REGION --format json | jq -r .address)

pks create-cluster $CLUSTER_NAME -e $MASTER_EXTERNAL_IP -p small
