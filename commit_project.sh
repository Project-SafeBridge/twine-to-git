#!/bin/bash

set -e

ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_URL="git@github.com:gersh/safebridge.git"
PROJECT_PATH="${ROOT_PATH}/safebridge"

UNBUILD_HTML="${ROOT_PATH}/stella.html"
PROJECT_UNBUILD_PATH="${PROJECT_PATH}/twee/unbuild"
PROJECT_UNBUILD_SRC_PATH="${PROJECT_UNBUILD_PATH}/src"
PROJECT_SRC_PATH="${PROJECT_PATH}/twee/src"
UNBUILD_SCRIPT="${PROJECT_PATH}/twee/unbuild.sh"

COMMIT_MESSAGE="${ROOT_PATH}/commit_message.txt"

BRANCH_PREFIX="users-"
DEVELOP_BRANCH="conversation-flow"

USER_NAME="$1"
USER_EMAIL="$2"

# Switch users
git -C "$PROJECT_PATH" config user.email "$USER_EMAIL"
git -C "$PROJECT_PATH" config user.name "$USER_NAME"

# Check out branch
echo "Switching branches..."
git -C "$PROJECT_PATH" reset --hard HEAD
git -C "$PROJECT_PATH" fetch
git -C "$PROJECT_PATH" checkout "${BRANCH_PREFIX}${USER_NAME}"
git -C "$PROJECT_PATH" pull

# Unbuild project
echo "Unbuilding project..."
mkdir -p "$PROJECT_UNBUILD_PATH"
rm -rf "$PROJECT_UNBUILD_PATH"
mkdir -p "$PROJECT_UNBUILD_PATH"
"$UNBUILD_SCRIPT" "$UNBUILD_HTML"

echo "Saving unbuild output..."
rm -rf "$PROJECT_SRC_PATH"
cp -r "$PROJECT_UNBUILD_SRC_PATH" "$PROJECT_SRC_PATH"

# Commit
echo "Committing..."
git -C "$PROJECT_SRC_PATH" add .
git -C "$PROJECT_SRC_PATH" diff-index --quiet --cached HEAD || git -C "$PROJECT_SRC_PATH" commit -F "$COMMIT_MESSAGE"

# Push
echo "Pushing..."
git -C "$PROJECT_PATH" push

# Clean up after ourselves
git -C "$PROJECT_PATH" reset --hard HEAD
git -C "$PROJECT_PATH" checkout "$DEVELOP_BRANCH"
git -C "$PROJECT_PATH" pull
rm "${COMMIT_MESSAGE}"
rm "$UNBUILD_HTML"

