#!/bin/bash

set -e

ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_URL="git@github.com:gersh/safebridge.git"
PROJECT_PATH="${ROOT_PATH}/safebridge"
BUILD_SCRIPT="${PROJECT_PATH}/twee/build.sh"
DEVELOP_BRANCH="conversation-flow"

# Clone repo
echo "Cloning..."
mkdir -p "$PROJECT_PATH"
rm -rf "$PROJECT_PATH"
git clone "$REPO_URL" "$PROJECT_PATH"

echo "Building to install bundle..."
git -C "$PROJECT_PATH" checkout "$DEVELOP_BRANCH"
"$BUILD_SCRIPT"

