#!/usr/bin/env bash
# cam_gen -> updated OpticalBar cameras -> joint adjustment -> fixed-camera evaluation
cam_gen "$IMAGE" --camera-type opticalbar --sample-file "$CAMERA_TEMPLATE" \
  --pixel-values "$GCP_PIXELS" --lon-lat-values "$GCP_LON_LAT" \
  --reference-dem "$DEM" --refine-camera -o "${CAM_GEN_CAMERA:?}"

bundle_adjust "${IMAGES[@]}" "${NEW_OPTICALBAR_CAMERAS[@]}" "$GCP" \
  -t opticalbar --datum WGS_1984 --nvm "$TIES_NVM" --skip-matching --fix-gcp-xyz \
  --inline-adjustments --solve-intrinsics --intrinsics-to-float other_intrinsics --intrinsics-to-share none \
  --heights-from-dem "$DEM" --heights-from-dem-uncertainty 10000 \
  --num-iterations 300 --num-passes 2 \
  --cost-function Cauchy --robust-threshold .5 --tri-weight .1 --tri-robust-threshold .1 \
  --camera-weight 0 --rotation-weight 0 --parameter-tolerance 1e-12 \
  --initial-transform "$IDENTITY_TRANSFORM" -o "${BA_PREFIX:?}"

bundle_adjust "${IMAGES[@]}" "${BA_ADJUSTED_CAMERAS[@]}" "$GCP" \
  -t opticalbar --datum WGS_1984 --nvm "$TIES_NVM" --fix-gcp-xyz \
  --num-iterations 0 --num-passes 1 --initial-transform "$IDENTITY_TRANSFORM" -o "${EVALUATION_PREFIX:?}"
