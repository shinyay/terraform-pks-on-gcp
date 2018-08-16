#!/bin/bash

cat <<EOF > config-director.yml
---
iaas-configuration:
  project: $GCP_PROJECT_ID
  default_deployment_tag: $GCP_RESOURCE_PREFIX
  auth_json: |
    $GCP_SERVICE_ACCOUNT_KEY
director-configuration:
  ntp_servers_string: metadata.google.internal
  resurrector_enabled: true
  post_deploy_enabled: true
  database_type: internal
  blobstore_type: local
az-configuration: $AVAILABILITY_ZONES
networks-configuration:
  icmp_checks_enabled: false
  networks:
  - name: $PKS_INFRASTRUCTURE_NETWORK_NAME
    service_network: false
    subnets:
    - iaas_identifier: $PKS_INFRASTRUCTURE_IAAS_IDENTIFIER
      cidr: $PKS_INFRASTRUCTURE_NETWORK_CIDR
      reserved_ip_ranges: $PKS_INFRASTRUCTURE_RESERVED_IP_RANGES
      dns: $PKS_INFRASTRUCTURE_DNS
      gateway: $PKS_INFRASTRUCTURE_GATEWAY
      availability_zone_names: $PKS_INFRASTRUCTURE_AVAILABILITY_ZONES
  - name: $PKS_MAIN_NETWORK_NAME
    service_network: false
    subnets:
    - iaas_identifier: $PKS_MAIN_IAAS_IDENTIFIER
      cidr: $PKS_MAIN_NETWORK_CIDR
      reserved_ip_ranges: $PKS_MAIN_RESERVED_IP_RANGES
      dns: $PKS_MAIN_DNS
      gateway: $PKS_MAIN_GATEWAY
      availability_zone_names: $PKS_MAIN_AVAILABILITY_ZONES
  - name: $PKS_SERVICES_NETWORK_NAME
    service_network: true
    subnets:
    - iaas_identifier: $PKS_SERVICES_IAAS_IDENTIFIER
      cidr: $PKS_SERVICES_NETWORK_CIDR
      reserved_ip_ranges: $PKS_SERVICES_RESERVED_IP_RANGES
      dns: $PKS_SERVICES_DNS
      gateway: $PKS_SERVICES_GATEWAY
      availability_zone_names: $PKS_SERVICES_AVAILABILITY_ZONES
network-assignment:
  network:
    name: $SINGLETON_AVAILABILITY_NETWORK
  singleton_availability_zone:
    name: $SINGLETON_AVAILABILITY_ZONE
security-configuration:
  trusted_certificates: "$OPS_MGR_TRUSTED_CERTS"
  vm_password_type: generate
resource-configuration:
  director:
    instance_type:
      id: $DIRECTOR_VM_TYPE
    internet_connected: $INTERNET_CONNECTED
  compilation:
    instance_type:
      id: large.cpu
    internet_connected: $INTERNET_CONNECTED
EOF
