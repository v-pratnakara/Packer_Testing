#!/bin/bash
set -e

echo "--------------- In Bash script ----------------"
echo "WINDOWS_VERSION_SELECTED: $WINDOWS_VERSION_SELECTED"

extract_var() {
  grep -E "^variable \"$1\"" -A 2 ./windows/variables.pkr.hcl | grep "default" | cut -d '"' -f2
}

dest_resource_group=$(extract_var "dest_resource_group")
dest_gallery_name=$(extract_var "dest_gallery_name")
dest_gallery_image_name="si-scus-sandbox-pscmp-ws${WINDOWS_VERSION_SELECTED}dcdg2x64t1-op-fhp-base"

echo "$dest_resource_group, $dest_gallery_name, $dest_gallery_image_name"

# Get the list of image versions
existing_versions=$(az sig image-version list --only-show-errors \
  --resource-group "$dest_resource_group" \
  --gallery-name "$dest_gallery_name" \
  --gallery-image-definition "$dest_gallery_image_name" \
  --query "[].name" -o tsv)

echo "Existing versions: $existing_versions"

# Find the latest version
image_version=$(echo "$existing_versions" | sort -V | tail -n 1)

if [[ -z "$image_version" ]]; then
  echo " No image versions found for $WINDOWS_VERSION_SELECTED"
  exit 1
fi

echo "Current $WINDOWS_VERSION_SELECTED version is $image_version"

# Export it for GitHub Actions
echo "LATEST_IMAGE_VERSION=$image_version" >> $GITHUB_ENV
