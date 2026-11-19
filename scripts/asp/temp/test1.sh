#!/usr/bin/env bash
# Joint adjustment with nonzero camera initialization
bundle_adjust "${IMAGES[@]}" "${NONZERO_CAMERAS[@]}" "$GCP" \
  -t opticalbar --datum WGS_1984 --nvm "$TIES_NVM" --skip-matching --fix-gcp-xyz \
  --inline-adjustments --solve-intrinsics --intrinsics-to-float other_intrinsics --intrinsics-to-share none \
  --cost-function Cauchy --robust-threshold 0.5 --num-passes 2 --num-iterations 1000 \
  --parameter-tolerance 1e-12 --tri-weight 0.1 --tri-robust-threshold 0.1 \
  --camera-weight 0 --rotation-weight 0 --min-triangulation-angle 0.1 -o "${BA_PREFIX:?}"
