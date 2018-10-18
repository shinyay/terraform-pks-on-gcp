#!/usr/bin/env fish

## PKS Image
### https://network.pivotal.io/products/pivotal-container-service/
set -x FILENAME pivotal-container-service-1.1.6-build.6.pivotal
set -x DOWNLOAD_URL https://network.pivotal.io/api/v2/products/pivotal-container-service/releases/191110/product_files/221573/download

## Access Token
### https://network.pivotal.io/users/dashboard/edit-profile
set -x REFRESH_TOKEN 27f8121e60d946e8b208299277a6d27e-r
set -x ACCESS_TOKEN (curl -s https://network.pivotal.io/api/v2/authentication/access_tokens -d "{\"refresh_token\":\"$REFRESH_TOKEN\"}" | jq -r .access_token)

## Download PKS
set -x PKS_ENV_PREFIX $ACCOUNT_NAME
set -x ZONE (gcloud compute instances list --filter name:$PKS_ENV_PREFIX-ops-manager | awk 'NR>1 {print $2}')

echo "===== INSTALL START: PIVNET CLI ====="

## Install PIVNET CLI on GCP
gcloud compute ssh ubuntu@$PKS_ENV_PREFIX-ops-manager \
    --zone $ZONE \
    --force-key-file-overwrite \
    --strict-host-key-checking=no \
    --quiet \
    --command "wget -O pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.55/pivnet-linux-amd64-0.0.55 && chmod +x pivnet && sudo mv pivnet /usr/local/bin/"

echo "===== INSTALL END: OM CLI ====="

echo "===== DOWNLOAD START: $FILENAME ====="

gcloud compute ssh ubuntu@$PKS_ENV_PREFIX-ops-manager \
    --zone $ZONE \
    --force-key-file-overwrite \
    --strict-host-key-checking=no \
    --quiet \
    --command "pivnet login --api-token=$REFRESH_TOKEN && pivnet accept-eula -p pivotal-container-service -r 1.1.6 && pivnet download-product-files -p pivotal-container-service -r 1.1.6 -i 221573"
#    --command "wget -O "$FILENAME" --header='Authorization: Bearer $ACCESS_TOKEN' $DOWNLOAD_URL" 

echo "===== DOWNLOAD END: $FILENAME ====="

echo "===== INSTALL START: OM CLI ====="

## Install OM CLI on GCP
gcloud compute ssh ubuntu@$PKS_ENV_PREFIX-ops-manager \
    --zone $ZONE \
    --force-key-file-overwrite \
    --strict-host-key-checking=no \
    --quiet \
    --command "wget -O om https://github.com/pivotal-cf/om/releases/download/0.38.0/om-linux && chmod +x om && sudo mv om /usr/local/bin/" 

echo "===== INSTALL END: OM CLI ====="

## Install PKS into Ops Manager
set -x PRODUCT_NAME (basename $FILENAME .pivotal | python -c 'print("-".join(raw_input().split("-")[:-2]))')
set -x PRODUCT_VERSION (basename $FILENAME .pivotal | python -c 'print("-".join(raw_input().split("-")[-2:]))')

echo "===== UPLOAD to OPSMANAGER START: $FILENAME ====="

gcloud compute ssh ubuntu@$PKS_ENV_PREFIX-ops-manager \
  --zone $ZONE \
  --force-key-file-overwrite \
  --strict-host-key-checking=no \
  --quiet \
  --command "om --target https://localhost -k -u $OPS_MGR_USR -p $OPS_MGR_PWD --request-timeout 3600 upload-product -p ~/$FILENAME"

echo "===== UPLOAD to OPSMANAGER END: $FILENAME ====="

## Stage PKS
echo "===== STAGE START: $FILENAME ====="

gcloud compute ssh ubuntu@$PKS_ENV_PREFIX-ops-manager \
  --zone $ZONE \
  --force-key-file-overwrite \
  --strict-host-key-checking=no \
  --quiet \
  --command "om --target https://localhost -k -u $OPS_MGR_USR -p $OPS_MGR_PWD stage-product -p $PRODUCT_NAME -v $PRODUCT_VERSION" 

echo "===== STAGE END: $FILENAME ====="

## Import Stemcell
echo "************************************************"
echo "Import Stemcell on the browser"
echo "https://network.pivotal.io/products/stemcells"
echo "************************************************"
