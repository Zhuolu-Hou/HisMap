#!/usr/bin/env bash
# cam_gen cameras -> joint adjustment with fixed GCP and default solver settings
bundle_adjust "${IMAGES[@]}" "${CAM_GEN_CAMERAS[@]}" "$GCP" \
  -t opticalbar --datum WGS_1984 --nvm "$TIES_NVM" --fix-gcp-xyz -o "${BA_PREFIX:?}"
