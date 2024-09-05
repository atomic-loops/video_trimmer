#!/bin/bash

# Get the git diff stat (summary of changes)
git_diff=$(git diff --cached --stat)

# Exit if there's no staged change
if [ -z "$git_diff" ]; then
    echo "No staged changes found."
    exit 1
fi

# Analyze the types of changes from the diff and assign commit type and message
if echo "$git_diff" | grep -q '\.dart'; then
    if echo "$git_diff" | grep -q 'new file'; then
        commit_type="feat"
        description="add new Dart feature"
    elif echo "$git_diff" | grep -q 'deleted'; then
        commit_type="refactor"
        description="remove unused Dart files"
    else
        commit_type="fix"
        description="update Dart logic"
    fi
elif echo "$git_diff" | grep -q '\.md'; then
    commit_type="docs"
    description="update documentation"
elif echo "$git_diff" | grep -q '\.(png|jpg|jpeg|svg|gif)'; then
    commit_type="style"
    description="update design assets"
elif echo "$git_diff" | grep -q '\.yaml'; then
    commit_type="chore"
    description="update dependencies or configurations"
else
    commit_type="chore"
    description="miscellaneous updates"
fi

# Generate the commit message
commit_message="$commit_type: $description"

# Add all changes and commit
git add .
git commit -m "$commit_message"

echo "Committed with message: $commit_message"
