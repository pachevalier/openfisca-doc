#!/usr/bin/env sh

CNAME="doc.openfisca.fr"

if [ "$CI" = "true" ]; then
    git config --global user.email "deploy@circleci"
    git config --global user.name "CircleCI deployment"
fi

echo "$CNAME" > _book/CNAME

gh-pages --dist _book

# Refresh the gh-pages branch in particular.
git fetch
