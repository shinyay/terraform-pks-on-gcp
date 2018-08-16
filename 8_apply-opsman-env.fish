#!/usr/bin/env fish

set -x OPSMAN_DOMAIN_OR_IP_ADDRESS (cat ./terraforming-pks-gcp/terraform.tfstate | jq -r '.modules[0].resources."google_compute_address.ops-manager-public-ip".primary.attributes.address')
om --target "https://$OPSMAN_DOMAIN_OR_IP_ADDRESS" \
   --skip-ssl-validation \
   --username "$OPS_MGR_USR" \
   --password "$OPS_MGR_PWD" \
   apply-changes \
   --ignore-warnings
