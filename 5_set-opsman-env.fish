#!/usr/bin/env fish
set -x GCP_PROJECT_ID $PROJECT_ID
set -x GCP_RESOURCE_PREFIX $ACCOUNT_NAME

set -x DIRECTOR_VM_TYPE large.disk
### In the case of Public IP: true
set -x INTERNET_CONNECTED false
set -x AUTH_JSON (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r .modules[0].outputs.AuthJSON.value)
set -x OPSMAN_DOMAIN_OR_IP_ADDRESS (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].resources."google_compute_address.ops-manager-public-ip".primary.attributes.address')
set -x GCP_PROJECT_ID (echo $AUTH_JSON | jq -r .project_id)
set -x GCP_RESOURCE_PREFIX (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Default Deployment Tag".value')
set -x GCP_SERVICE_ACCOUNT_KEY (echo $AUTH_JSON)
set -x AVAILABILITY_ZONES (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Availability Zones".value | map({name: .})' | tr -d '\n' | tr -d '"')
set -x PKS_INFRASTRUCTURE_NETWORK_NAME (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Infrastructure Network Name".value')
set -x PKS_INFRASTRUCTURE_IAAS_IDENTIFIER (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Infrastructure Network Google Network Name ".value')
set -x PKS_INFRASTRUCTURE_NETWORK_CIDR (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Infrastructure Network CIDR".value')
set -x PKS_INFRASTRUCTURE_RESERVED_IP_RANGES (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Infrastructure Network Reserved IP Ranges".value')
set -x PKS_INFRASTRUCTURE_DNS (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Infrastructure Network DNS".value')
set -x PKS_INFRASTRUCTURE_GATEWAY (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Infrastructure Network Gateway".value')
set -x PKS_INFRASTRUCTURE_AVAILABILITY_ZONES (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Availability Zones".value' | tr -d '\n')
set -x PKS_MAIN_NETWORK_NAME (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Main Network Name".value')
set -x PKS_MAIN_IAAS_IDENTIFIER (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Main Network Google Network Name ".value')
set -x PKS_MAIN_NETWORK_CIDR (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Main Network CIDR".value')
set -x PKS_MAIN_RESERVED_IP_RANGES (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Main Network Reserved IP Ranges".value')
set -x PKS_MAIN_DNS (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Main Network DNS".value')
set -x PKS_MAIN_GATEWAY (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Main Network Gateway".value')
set -x PKS_MAIN_AVAILABILITY_ZONES (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Availability Zones".value' | tr -d '\n')
set -x PKS_SERVICES_NETWORK_NAME (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Service Network Name".value')
set -x PKS_SERVICES_IAAS_IDENTIFIER (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Service Network Google Network Name ".value')
set -x PKS_SERVICES_NETWORK_CIDR (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Service Network CIDR".value')
set -x PKS_SERVICES_RESERVED_IP_RANGES (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Services Network Reserved IP Ranges".value')
set -x PKS_SERVICES_DNS (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Services Network DNS".value')
set -x PKS_SERVICES_GATEWAY (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Services Network Gateway".value')
set -x PKS_SERVICES_AVAILABILITY_ZONES (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Availability Zones".value' | tr -d '\n')
set -x SINGLETON_AVAILABILITY_NETWORK (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Infrastructure Network Name".value')
set -x SINGLETON_AVAILABILITY_ZONE (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].outputs."Availability Zones".value | .[0]')
