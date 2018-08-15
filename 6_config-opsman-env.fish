#!/usr/bin/env fish

om --target https://$OPSMAN_DOMAIN_OR_IP_ADDRESS \
   --skip-ssl-validation \
   --username $OPS_MGR_USR \
   --password $OPS_MGR_PWD \
   configure-director \
   --config config-director.yml
