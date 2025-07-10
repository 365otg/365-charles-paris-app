#!/bin/bash

# Define your GitHub username and repository name
USER_NAME="365otg"
REPO_NAME="365-charles-paris-app"
REPO_URL="https://${USER_NAME}.github.io/${REPO_NAME}"

echo "Starting deployment to GitHub Pages for ${REPO_URL}"

# 1. Clear previous build and node_modules for a clean slate
echo "Cleaning old build files and node_modules..."
rm -rf build node_modules package-lock.json

# 2. Reinstall dependencies
echo "Reinstalling dependencies..."
npm install

# 3. Build the React app with the correct PUBLIC_URL
echo "Building React application with PUBLIC_URL=${REPO_NAME}..."
# The build command is slightly different depending on your OS (macOS/Linux vs Windows Git Bash)
# Using npx directly with react-scripts build is often more reliable
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # For macOS/Linux
  PUBLIC_URL="/${REPO_NAME}" npx react-scripts build
else
  # For Windows Git Bash (needs `winpty` or similar if direct execution fails)
  # Try without winpty first, add if needed: winpty npx react-scripts build
  PUBLIC_URL="/${REPO_NAME}" npx react-scripts build
fi

# Check if build was successful
if [ $? -ne 0 ]; then
  echo "React build failed. Aborting deployment."
  exit 1
fi
echo "Build complete."

# 4. Deploy to gh-pages branch using gh-pages package
echo "Deploying to gh-pages branch..."
npx gh-pages -d build --repo "https://github.com/${USER_NAME}/${REPO_NAME}.git"

# Check if deploy was successful
if [ $? -ne 0 ]; then
  echo "gh-pages deployment failed."
  exit 1
fi

echo "Deployment successful!"
echo "Your site should be live at: ${REPO_URL}"

