#!/usr/bin/env fish

set -x GUID (om \
    --target "https://$OPSMAN_DOMAIN_OR_IP_ADDRESS" \
    --username "$OPS_MGR_USR" \
    --password "$OPS_MGR_PWD" \
    --skip-ssl-validation \
    curl \
    --silent \
    --path "/api/v0/staged/products" \
    -x GET \
    | jq -r '.[] | select(.type == "pivotal-container-service") | .guid')

set -x ADMIN_SECRET (om \
    --target "https://$OPSMAN_DOMAIN_OR_IP_ADDRESS" \
    --username "$OPS_MGR_USR" \
    --password "$OPS_MGR_PWD" \
    --skip-ssl-validation \
    curl \
    --silent \
    --path "/api/v0/deployed/products/$GUID/credentials/.properties.pks_uaa_management_admin_client" \
    -x GET \
    | jq -r '.credential.value.secret'
)

echo "==========================="
echo "ADMIN_SECRET: $ADMIN_SECRET"
echo "==========================="

set -x UAA_URL https://api-$PKS_DOMAIN:8443

gcloud compute ssh ubuntu@$PKS_ENV_PREFIX-ops-manager \
  --zone $ZONE \
  --force-key-file-overwrite \
  --strict-host-key-checking=no \
  --quiet \
  --command "uaac target $UAA_URL --skip-ssl-validation && uaac token client get admin -s $ADMIN_SECRET"
