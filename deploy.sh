#!/usr/bin/env bash

if [ "$CI" = "true" ]; then
    git config --global user.email "deploy@circleci"
    git config --global user.name "CircleCI deployment"
fi

gh-pages --dist _book

# Refresh the gh-pages branch in particular.
git fetch
