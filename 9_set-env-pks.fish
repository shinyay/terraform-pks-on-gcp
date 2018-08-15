#!/usr/bin/env fish

set -x OPSMAN_DOMAIN_OR_IP_ADDRESS (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].resources."google_compute_address.ops-manager-public-ip".primary.attributes.address')
set -x PKS_API_IP (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].resources."google_compute_address.pks-api-ip".primary.attributes.address')
set -x PKS_DOMAIN (echo $PKS_API_IP | tr '.' '-').sslip.io
set -x AUTH_JSON (cat terraforming-pks-gcp/terraform.tfstate | jq -r .modules[0].outputs.AuthJSON.value)
set -x GCP_PROJECT_ID (echo $AUTH_JSON | jq -r .project_id)
set -x GCP_NETWORK (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].resources."google_compute_network.pks-network".primary.id')
set -x GCP_RESOURCE_PREFIX (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Default Deployment Tag".value')
set -x PKS_MAIN_NETWORK_NAME (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Main Network Name".value')
set -x PKS_SERVICES_NETWORK_NAME (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Service Network Name".value')
set -x SINGLETON_AVAILABILITY_ZONE (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Availability Zones".value | .[0]')
set -x MULTI_AVAILABILITY_ZONES (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Availability Zones".value' | tr -d '\n')
set -x AVAILABILITY_ZONES (cat terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Availability Zones".value | map({name: .})' | tr -d '\n' | tr -d '"')
set -x UAA_URL api-$PKS_DOMAIN
set -x LB_NAME "tcp:$GCP_RESOURCE_PREFIX-pks-api"

