#!/usr/bin/env bash
set -e

REGISTRY="rinchen.cnb.csic.es"
IMAGE="apptainer-"
FLAVOURS=["base", "spa", "tomo", "full"]

for FLAVOUR in "${FLAVOURS[@]}"; do
  FULL_IMAGE="${IMAGE}-${FLAVOUR}"
  echo "$FULL_IMAGE tags in $REGISTRY:"
  TAGS=$(curl -s "https://$REGISTRY/v2/$FULL_IMAGE/tags/list" | jq -r '.tags[]' | sort -V)

  if [[ -z "$TAGS" ]]; then
    echo "No tags found for $FULL_IMAGE."
  else
    echo "Tags found for $FULL_IMAGE:"
    echo "$TAGS"
  fi
  echo "----------------------------------------"
done
