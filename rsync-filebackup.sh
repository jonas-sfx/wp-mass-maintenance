#!/bin/bash

## filename     rsync-filebackup.sh
## description: run filesync online->local for each instance
##              and create a zst archive of the synced folder
## author:      jonas@sfxonline.de
## =======================================================================

for row in $(jq -r '.[] | @base64' data/sites.json); do
  _jq() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'

  mkdir -p 'exports/files-'$(_jq '.short')
  
  rsync -avP \
    --exclude='*.mp4'  \
    --exclude='*.psd'  \
    --exclude='wp-content/backups-*/*'  \
    --exclude='wp-content/et-cache/*'  \
    --exclude='wp-content/gallery/*'  \
    --exclude='wp-content/nitropack/*' \
    --exclude='wp-content/uploads/*' \
    --exclude='wp-content/webp-express/webp-images/*' \
    --delete \
    "$(_jq '.host'):$(_jq '.webroot')/*" "exports/files-$(_jq '.short')/"

  tar --zstd -cf exports/$(date +"%Y%m%d-%H%M")-files-$(_jq '.short').tar.zst exports/files-$(_jq '.short')/

done