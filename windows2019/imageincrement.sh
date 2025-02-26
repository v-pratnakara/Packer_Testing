#!/bin/bash

# Get the list of image versions
existing_versions=$(az sig image-version list \
    --resource-group "$IFP_RESOURCE_GROUP" \
    --gallery-name "$IFP_GALLERY_NAME" \
    --gallery-image-definition "$IFP_IMAGE_DEFINITION" \
    --query "[].name" -o tsv)

echo "Existing versions: $existing_versions"

# Find the latest version
latest_version=$(echo "$existing_versions" | sort -V | tail -n1)

# Default to version 1.0.0 if no versions exist
if [ -z "$latest_version" ]; then
    new_version="1.0.0"
else
    # Split the version into components
    IFS='.' read -r major minor patch <<< "$latest_version"
    echo "Major: $major, Minor: $minor, Patch: $patch"

    # Remove leading zeros from patch
    patch=$(echo "$patch" | sed -e 's/^0*//')

    # Increment the patch version
    new_patch=$((patch + 1))

    new_version="$major.$minor.$new_patch"
fi

# Set version as environment variable which can be used in further steps of the pipeline
echo "IMAGE_VERSION=$new_version" >> "$GITHUB_ENV"

echo "New image version:
 