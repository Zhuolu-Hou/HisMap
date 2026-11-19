#!/usr/bin/env bash
# cam_gen -> GCP-only adjustment -> joint GCP and tie adjustment
cam_gen "$IMAGE" --camera-type opticalbar --sample-file "$CAMERA_TEMPLATE" \
  --reference-dem "$DEM" --lon-lat-values "$CORNER_LON_LAT" --refine-camera -o "${CAM_GEN_CAMERA:?}"

bundle_adjust "${GCP_IMAGES[@]}" "${CAM_GEN_CAMERAS[@]}" "$INIT_GCP" \
  --datum WGS_1984 --num-passes 2 --robust-threshold 10 \
  --inline-adjustments --skip-matching --fix-gcp-xyz -o "${GCP_ONLY_PREFIX:?}"

bundle_adjust "${IMAGES[@]}" "${GCP_ADJUSTED_CAMERAS[@]}" "$GCP" \
  --datum WGS_1984 --nvm "$TIES_NVM" --skip-matching --fix-gcp-xyz \
  --heights-from-dem "$DEM" --heights-from-dem-uncertainty 30 \
  --num-passes 1 --num-iterations 300 --robust-threshold 10 --inline-adjustments -o "${BA_PREFIX:?}"
