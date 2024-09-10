#!/bin/bash

# Path to the _config.yml file
CONFIG_FILE="_config.yml"

# Themes
THEME1="remote_theme: fongandrew/hydeout"
THEME2="remote_theme: jekyll/minima"

# Function to swap the theme in _config.yml
swap_theme() {
    if grep -q "$THEME1" "$CONFIG_FILE"; then
        sed -i "s|$THEME1|$THEME2|" "$CONFIG_FILE"
        sed -i '2s/index/page/' index.html
        echo "Swapped to Minima theme."
    elif grep -q "$THEME2" "$CONFIG_FILE"; then
        sed -i "s|$THEME2|$THEME2|" "$CONFIG_FILE"
        sed -i '2s/page/index/' index.html
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

make