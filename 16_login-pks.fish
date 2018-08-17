#!/usr/bin/env fish

set -x PKS_API_URL https://api-$PKS_DOMAIN:9021

pks login -k -a $PKS_API_URL -u $PKS_USER -p $PKS_PASSWORD
