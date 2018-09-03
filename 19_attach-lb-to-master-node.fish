#!/usr/bin/env fish

set -x CLUSTER_UUID (pks cluster $CLUSTER_NAME --json | jq -r .uuid)
set -x MASTER_INSTANCE_NAME (gcloud compute instances list --filter "tags:service-instance-$CLUSTER_UUID-master" | awk 'NR>1 {print $1}')
set -x MASTER_INSTANCE_ZONE (gcloud compute instances list --filter "tags:service-instance-$CLUSTER_UUID-master" | awk 'NR>1 {print $2}')

gcloud compute target-pools add-instances $CLUSTER_NAME-master-api \
      --instances $MASTER_INSTANCE_NAME \
      --instances-zone $MASTER_INSTANCE_ZONE \
      --region $GCP_REGION
gcloud compute forwarding-rules create $CLUSTER_NAME-master-api-8443 \
      --region $GCP_REGION \
      --address $CLUSTER_NAME-master-api-ip \
      --target-pool $CLUSTER_NAME-master-api  \
      --ports 8443
