#!/bin/bash

# Check if theme repository link is provided
if [ -z "$1" ]; then
  echo "Usage: ./theme_fetch.sh <theme_repo>"
  exit 1
fi

# Extract the new theme user and theme name from the repository link
theme_repo=$1
new_theme_user=$(echo "$theme_repo" | cut -d '/' -f 4)
new_theme_name=$(echo "$theme_repo" | cut -d '/' -f 5)

# Backup _includes and _layouts
echo "Backing up _includes and _layouts..."
cp -r _includes _includes_bak
cp -r _layouts _layouts_bak

# Clone the new theme repository
echo "Cloning new theme repository..."
git clone "$theme_repo" temp_theme

# Merge the new theme files with the existing ones, replacing as needed
echo "Merging new theme _includes and _layouts..."
rsync -av --ignore-existing temp_theme/_includes/ _includes/
rsync -av --ignore-existing temp_theme/_layouts/ _layouts/

# Clean up the temporary theme folder
rm -rf temp_theme

# Update the _config.yml with the new theme
echo "Updating _config.yml..."
sed -i.bak "s/remote_theme:.*/remote_theme: $new_theme_user\/$new_theme_name/" _config.yml

echo "Theme changed successfully, with existing files preserved!"
