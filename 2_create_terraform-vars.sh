#!/usr/bin/env bash

cat << EOF > terraform.tfvars
env_prefix         = "${ACCOUNT_NAME}"
project          = "${PROJECT_ID}"
region           = "asia-northeast1"
zones            = ["asia-northeast1-a", "asia-northeast1-b", "asia-northeast1-c"]
opsman_image_url = "https://storage.googleapis.com/ops-manager-asia/pcf-gcp-2.2-build.300.tar.gz"
nat_machine_type = "f1-micro"
opsman_machine_type = "n1-standard-1"
service_account_key = <<EOK
$(cat terraform.key.json)
EOK
EOF

mv terraform.tfvars terraforming-pks-gcp
