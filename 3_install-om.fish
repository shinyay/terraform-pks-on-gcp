#!/usr/bin/env fish

curl -Lo om https://github.com/pivotal-cf/om/releases/download/0.39.0/om-darwin
chmod +x om
mv om /usr/local/bin/
curl -Lo pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.53/pivnet-linux-amd64-0.0.53
chmod +x pivnet
mv pivnet /usr/local/bin/
