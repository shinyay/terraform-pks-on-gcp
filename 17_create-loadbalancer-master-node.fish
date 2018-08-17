#!/usr/bin/env fish

set -x CLUSTER_NAME demo-pks

set -x GCP_REGION (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].resources."google_compute_subnetwork.pks-subnet".primary.attributes.region')

gcloud compute addresses create $CLUSTER_NAME-master-api-ip --region $GCP_REGION
gcloud compute target-pools create $CLUSTER_NAME-master-api --region $GCP_REGION
