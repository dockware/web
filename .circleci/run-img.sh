#!/bin/bash

cat <<EOT >> body.json
{
  "parameters":
      {
          "imageName": "flex",
          "imageTag" : "$2",
          "setLatest" : $3
      }
}
EOT

cat body.json

PROJECT_NAME="flex"

curl -X POST -d @body.json \
     -H "Content-Type: application/json" \
     -H "Circle-Token: $CIRCLE_TOKEN" \
     "https://circleci.com/api/v2/project/github/dockware/${PROJECT_NAME}/pipeline"

rm -rf body.json

 