#!/bin/bash

# Path to the _config.yml file
CONFIG_FILE="_config.yml"

# Themes
HYDEOUT_THEME="remote_theme: fongandrew/hydeout"
MINIMA_THEME="remote_theme: pages-themes/minima@v0.2.0"

# Function to swap the theme in _config.yml
swap_theme() {
    if grep -q "$HYDEOUT_THEME" "$CONFIG_FILE"; then
        sed -i "s|$HYDEOUT_THEME|$MINIMA_THEME|" "$CONFIG_FILE"
        echo "Swapped to Minima theme."
    elif grep -q "$MINIMA_THEME" "$CONFIG_FILE"; then
        sed -i "s|$MINIMA_THEME|$HYDEOUT_THEME|" "$CONFIG_FILE"
        echo "Swapped to Hydeout theme."
    else
        echo "No recognized theme found in _config.yml."
    fi
}

# Function to swap the contents of two directories
swap_directories() {
    local DIR1=$1
    local DIR2=$2

    if [ -d "$DIR1" ] && [ -d "$DIR2" ]; then
        TEMP_DIR=$(mktemp -d)
        mv "$DIR1"/* "$TEMP_DIR"/
        mv "$DIR2"/* "$DIR1"/
        mv "$TEMP_DIR"/* "$DIR2"/
        rmdir "$TEMP_DIR"
        echo "Swapped contents of $DIR1 and $DIR2."
    else
        echo "One or both directories do not exist."
    fi
}

# Swap the theme in _config.yml
swap_theme

# Swap the contents of _includes and _includes_bak
swap_directories "_includes" "_includes_bak"

# Swap the contents of _layouts and _layouts_bak
swap_directories "_layouts" "_layouts_bak"
