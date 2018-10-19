#!/usr/bin/env fish

curl -Lo om https://github.com/pivotal-cf/om/releases/download/0.41.0/om-darwin
chmod +x om
mv om /usr/local/bin/
curl -Lo pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.54/pivnet-darwin-amd64-0.0.54
chmod +x pivnet
mv pivnet /usr/local/bin/
