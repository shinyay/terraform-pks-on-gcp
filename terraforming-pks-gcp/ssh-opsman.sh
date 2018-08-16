#!/bin/bash

opsman=$(cat terraform.tfstate | jq -r '.modules[0].resources."google_compute_instance.ops-manager".primary.id')
gcloud compute ssh $opsman