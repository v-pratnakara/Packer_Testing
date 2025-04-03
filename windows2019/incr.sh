#!/bin/bash
extract_var() {
    grep -E "^variable \"${1}\"" -A 2 ./windows/variables.pkr.hcl | grep "default" | cut -d '"' -f2
}

dest_resource_group=$(extract_var "dest_resource_group")
dest_gallery_name=$(extract_var "dest_gallery_name")
dest_gallery_image_name=$(extract_var "dest_gallery_image_name")
# echo "$dest_resource_group, $dest_gallery_name, $dest_gallery_image_name "

# Get the list of image versions
existing_versions=$(az sig image-version list \
    --resource-group $dest_resource_group \
    --gallery-name $dest_gallery_name \
    --gallery-image-definition $dest_gallery_image_name \
    --query "[].name" -o tsv )
echo "Existing versions: $existing_versions"

# Find the latest version
latest_version=$(echo "$existing_versions" | sort -V | tail -n 1 )

# Default to version 1.0.0 if no versions exist
if [[ -z "$latest_version" ]]; then
    new_version="1.0.0"
else
    # Split the version into components
    IFS='.' read -r major minor patch <<< "$latest_version"
    echo "Major minor patch: $major $minor $patch"
    patch=`echo $patch | sed -e "s/^0*//g"`
    
    # Increment the patch version
    new_patch=$((patch + 1))
    new_version="$major.$minor.$new_patch"
fi

echo "New version: $new_version"

# Set version as environment variable which can be used in further steps of the pipeline
echo "IMAGE_VERSION=$new_version" >> $GITHUB_ENV
