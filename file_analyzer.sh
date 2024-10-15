#!/bin/bash

# Function to display usage information
function hashSHA256(){
    sha256sum "$1" >> "$2"
}

function script_usage() {
    echo " "
    echo "Welcome to the Evidence Analyzer!"
    echo " "
    echo "SYNOPSIS"
    echo " "
    echo "  $0 [OPTION] [source_directory]"
    echo " "
    echo "DESCRIPTION"
    echo " "
    echo "  This script helps manage media evidence:"
    echo " "
    echo "  > Organizes evidence into Images, Videos, and Others"
    echo "  > Copies files based on user-specified options"
    echo "  > It can also get the hash number of the copied files"
    echo " "
    echo " The Evidence Folder contains quick to access information. Below is a sample folder/directory of an evidence"
    echo " 		sample evidence folder: evidece_randomnumber_nameofOrginalDirectory_Date_Time"
    echo " "
    echo "OPTIONS"
    echo "  -h:     Display help information"
    echo "  -v:     Copy only video files"
    echo "  -i:     Copy only image files"
    echo "  -a:     Copy all other file types (.txt, etc)"
    echo "  -s:     Creates a hash of the individual files (copied files only)"
    echo " "
    echo "   NOTE1: -s option can only be used in conjunctioned with another option. "
    echo "   NOTE2: This script uses SHA 256."
    echo " "
    echo "AUTHOR"
    echo " "
    echo "  Written by Mark Nudalo, October 12, 2024"
}

# Function to copy and categorize files
function copy_files() {
    local copy_videos=$1
    local copy_images=$2
    local copy_all=$3
    local create_hashes=$4
    local source_dir="$5"

    local evidence_dir="Evidence"


    # Check if a source directory is provided
    if [ -z "$source_dir" ]; then
    	echo "Error: No source directory provided!"
	echo " "
    	exit 1
    fi


    # Ensure the provided source is a valid directory
    if [ ! -d "$source_dir" ]; then
    	echo "Error: Provided source '$source_dir' is not a valid directory!"
	echo " "
    	exit 1
    fi

    # At this point, we have a valid source directory; now we can create the evidence directory

    if [ ! -d "$evidence_dir" ]; then
    	mkdir "$evidence_dir"
    	echo "Directory $evidence_dir created."
    	echo " "
    else
    	echo "Directory $evidence_dir already exists."
    	echo " "
    fi

    # Making a  directory with date and time
    initial_dir_name=$(basename "$source_dir")

    #Create a random three diigt number to help with accessibility.
    random_number=$(shuf -i 100-999 -n 1)
    current_time=$(date +"%Y-%m-%d_%H:%M:%S")
    destination_dir="${evidence_dir}/evidence_${random_number}_${initial_dir_name}_${current_time}"
    mkdir "$destination_dir"


    # Create subdirectories based on the user's options
    if [[ "$copy_videos" == true ]]; then
        mkdir -p "$destination_dir/Videos"
    fi

    if [[ "$copy_images" == true ]]; then
        mkdir -p "$destination_dir/Images"
    fi

    if [[ "$copy_all" == true ]]; then
        mkdir -p "$destination_dir/Others"
    fi

    #if [[ "$create_hashes" == true ]] then
	#touch "$destination_dir/hashes.txt"
    #fi

    # Loop through files and sort based on file type
    for file in "$source_dir"/*; do
        if [[ -f $file ]]; then
            local file_extension="${file##*.}"
            local copied_file=""
	    

	    #Checking for video file types
            if echo "$file_extension" | grep -qE '^(mp4|mkv|avi)$'; then
                if [[ "$copy_videos" == true || "$copy_all" == true ]]; then
                    cp "$file" "$destination_dir/Videos/"
                    echo "Copied $(basename "$file") to $destination_dir/Videos/"
		    copied_file="$destination_dir/Videos/$(basename "$file")"
                fi
	    fi 

            # Check for image file types
            if echo "$file_extension" | grep -qE '^(jpg|jpeg|png|gif)$'; then
                if [[ "$copy_images" == true || "$copy_all" == true ]]; then
                    cp "$file" "$destination_dir/Images/"
                    echo "Copied $(basename "$file") to $destination_dir/Images/"
		    copied_file="$destination_dir/Images/$(basename "$file")"
                fi
	    fi

            # If it is any other file and copy_all is true, copy to the others directory
            if [[ "$copy_all" == true && -z "$copied_file" ]]; then
                cp "$file" "$destination_dir/Others/"
                echo "Copied $(basename "$file") to $destination_dir/Others/"
		copied_file="$destination_dir/Others/$(basename "$file")"
            fi

            # Create hashes for original and copied files if the option is selected
            if [[ "$create_hashes" == true && -n "$copied_file" ]]; then
		    local hash_file="${destination_dir}/${initial_dir_name}_SHA256.txt"
		    
		    #hashed only copied file
		    hashSHA256 "$copied_file" "$hash_file" 
                    echo "Hash for copied file $(basename "copied_file") added to $hash_file"		
		
		files_hashed=true
            fi
	fi
done

    echo " "
    echo "Files have been successfully copied and categorized into $destination_dir."
    echo " "
}

# Set default values for flags
copy_videos=false
copy_images=false
copy_all=false
create_hashes=false

# Process command-line options
while getopts ":hvdias" opt; do
    case $opt in
        h)
            script_usage
            exit 0
            ;;
        v)
            copy_videos=true
            ;;
        i)
            copy_images=true
            ;;
        a)
            copy_all=true
            ;;
	s)
	    create_hashes=true
	    ;;
        \?)
            echo "Invalid option: -$OPTARG"
            script_usage
            exit 1
            ;;
    esac
done

# Shift to capture the source directory argument after the options
shift $((OPTIND - 1))

# Validate that one of the copy options is selected
if [[ "$copy_videos" == false && "$copy_images" == false && "$copy_all" == false ]]; then
    echo "Error: No copy option provided. Check OPTIONS for more detail."
    echo "./file_analyzer -h"
    exit 1

fi



# Call the copy_files function with the relevant options and the source directory
copy_files "$copy_videos" "$copy_images" "$copy_all" "$create_hashes" "$1"

if $files_hashed; then
	echo "Files Hasehed"
fi
