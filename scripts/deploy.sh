#!/bin/bash
# Script to deploy to GitHub Pages

# Activate virtual environment
source venv/bin/activate

# Deploy to GitHub Pages
mkdocs gh-deploy

echo "Site deployed to GitHub Pages!"
