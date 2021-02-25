#!/bin/bash

PKG_DIR="com/github/danbrough/maplibre-plugins-android/"
REPO_SRV="dan@h1"
REPO_PATH="/srv/https/maven"

cd `dirname $0` 

./gradlew publishToMavenLocal || exit 1

cd ~/.m2/repository/
echo at `pwd`
cd $PKG_DIR || exit 1

find -type f -name maven-metadata-local.xml  | while read n; do
  mv "$n" $(echo "$n" | sed -e 's:maven-metadata-local:maven-metadata:g')
done

ssh "$REPO_SRV" mkdir -p "$REPO_PATH/$PKG_DIR"
rsync -avHSx   . "$REPO_SRV:$REPO_PATH/$PKG_DIR"

