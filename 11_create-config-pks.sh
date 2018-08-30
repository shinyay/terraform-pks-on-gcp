#!/bin/bash

om_generate_cert() (
  set -eu
  local domains="$1"
  local data=$(echo $domains | jq --raw-input -c '{"domains": (. | split(" "))}')
  local response=$(
    om --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
       --username "$OPS_MGR_USR" \
       --password "$OPS_MGR_PWD" \
       --skip-ssl-validation \
       curl \
       --silent \
       --path "/api/v0/certificates/generate" \
       -x POST \
       -d $data
    )
    echo "$response"
)

CERTIFICATES=$(om_generate_cert "*.sslip.io *.x.sslip.io")
CERT_PEM=`echo $CERTIFICATES | jq -r '.certificate' | sed 's/^/        /'`
KEY_PEM=`echo $CERTIFICATES | jq -r '.key' | sed 's/^/        /'`

GCP_MASTER_SERVICE_ACCOUNT_KEY=$(cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs.pks_master_node_service_account_key.value' | jq -r '.client_email')
GCP_WORKER_SERVICE_ACCOUNT_KEY=$(cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs.pks_worker_node_service_account_key.value' | jq -r '.client_email')

cat <<EOF > config-pks.yml
---
product-properties:
  .pivotal-container-service.pks_tls:
    value:
      cert_pem: |
$CERT_PEM
      private_key_pem: |
$KEY_PEM
  .properties.plan1_selector:
    value: Plan Active
  .properties.plan1_selector.active.master_az_placement:
    value: [  $SINGLETON_AVAILABILITY_ZONE  ]
  .properties.plan1_selector.active.worker_az_placement:
    value: $MULTI_AVAILABILITY_ZONES
  .properties.plan1_selector.active.master_vm_type:
    value: micro
  .properties.plan1_selector.active.worker_vm_type:
    value: medium
  .properties.plan1_selector.active.worker_persistent_disk_type:
    value: "102400"
  .properties.plan1_selector.active.worker_instances:
    value: 3
  .properties.plan2_selector:
    value: Plan Inactive
  .properties.plan3_selector:
    value: Plan Inactive
  .properties.cloud_provider:
    value: GCP
  .properties.cloud_provider.gcp.project_id:
    value: $GCP_PROJECT_ID
  .properties.cloud_provider.gcp.network:
    value: $GCP_NETWORK
  .properties.cloud_provider.gcp.master_service_account:
    value: $GCP_MASTER_SERVICE_ACCOUNT_KEY
  .properties.cloud_provider.gcp.worker_service_account:
    value: $GCP_WORKER_SERVICE_ACCOUNT_KEY
  .properties.pks_api_hostname:
    value: $UAA_URL
  .properties.telemetry_selector:
    value: disabled
network-properties:
  network:
    name: $PKS_MAIN_NETWORK_NAME
  service_network:
    name: $PKS_SERVICES_NETWORK_NAME
  other_availability_zones: $AVAILABILITY_ZONES
  singleton_availability_zone:
    name: $SINGLETON_AVAILABILITY_ZONE
resource-config:
  pivotal-container-service:
    instance_type:
      id: micro
    elb_names:
    - $LB_NAME
    internet_connected: $INTERNET_CONNECTED
EOF

