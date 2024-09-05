#!/bin/bash

# Get the list of all changes: modified, untracked, and deleted files
files=$(git ls-files --modified --others --deleted --exclude-standard)

# Exit if no files are found
if [ -z "$files" ]; then
    echo "No changes to commit."
    exit 1
fi

# Loop through each file and determine the type of change
for file in $files
do
    # Get only the file name
    filename=$(basename "$file")

    if git ls-files --deleted | grep -q "$file"; then
        commit_type="refactor"
        description="remove file"
    elif git ls-files --others --exclude-standard | grep -q "$file"; then
        commit_type="feat"
        description="add new file"
    else
        # File has been modified, check if it's a specific type
        if [[ $file == *.dart ]]; then
            commit_type="fix"
            description="update Dart logic"
        elif [[ $file == *.md ]]; then
            commit_type="docs"
            description="update documentation"
        elif [[ $file == *.png || $file == *.jpg || $file == *.jpeg || $file == *.svg || $file == *.gif ]]; then
            commit_type="style"
            description="update design assets"
        elif [[ $file == *.yaml ]]; then
            commit_type="chore"
            description="update configuration"
        else
            commit_type="chore"
            description="miscellaneous updates"
        fi
    fi

    # Generate the commit message using only the file name
    commit_message="$commit_type: $description for $filename"

    # Stage the current file and commit (ensure we handle deleted files)
    if [[ "$description" == "remove file" ]]; then
        git rm "$file"
    else
        git add "$file"
    fi
    
    git commit -m "$commit_message"
    echo "Committed $filename with message: $commit_message"
done
