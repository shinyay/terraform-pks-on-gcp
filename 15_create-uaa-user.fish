#!/usr/bin/env fish

set -x PKS_USER demo@example.com 
set -x PKS_PASSWORD password1234

gcloud compute ssh ubuntu@$PKS_ENV_PREFIX-ops-manager \
  --zone $ZONE \
  --force-key-file-overwrite \
  --strict-host-key-checking=no \
  --quiet \
  --command "uaac user add $PKS_USER --emails $PKS_USER -p $PKS_PASSWORD"

gcloud compute ssh ubuntu@$PKS_ENV_PREFIX-ops-manager \
  --zone $ZONE \
  --force-key-file-overwrite \
  --strict-host-key-checking=no \
  --quiet \
  --command "uaac member add pks.clusters.admin $PKS_USER"
