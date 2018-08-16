#!/usr/bin/env fish

om --target "https://$OPSMAN_DOMAIN_OR_IP_ADDRESS" \
   --username $OPS_MGR_USR \
   --password $OPS_MGR_PWD \
   --skip-ssl-validation \
   configure-product \
   --product-name $PRODUCT_NAME \
   --config config-pks.yml
