#!/usr/bin/env fish

set -x PROJECT_ID <PROJECT ID on GCP> 
set -x ACCOUNT_NAME <ACCOUNT NAME for Terraform>

gcloud iam service-accounts create $ACCOUNT_NAME --display-name "Terraform Account"
gcloud iam service-accounts keys create "terraform.key.json" --iam-account "$ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"
gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" --role 'roles/owner'
