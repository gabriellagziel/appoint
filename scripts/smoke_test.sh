#!/bin/bash
set -e

curl "$APP_URL"
curl https://firestore.googleapis.com/v1/projects/$FIREBASE_PROJECT/databases/(default)/documents
