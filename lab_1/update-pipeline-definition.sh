#!/usr/bin/env bash

JSON=$1
branch="main"
date=$(date +"%d_%m_%Y")
NEW_JSON=./pipeline-$date.json
POLL_FOR_SOURCE_CHANGES="false"
ARGUMENT_LIST=(
  "branch"
  "owner"
  "poll-for-source-changes"
  "configuration"
)

echo "Modifying pipeline definition: $JSON"
cp $JSON $NEW_JSON

echo "Removing metadata"
jq 'del(.metadata)' $NEW_JSON > tmp.json && mv tmp.json $NEW_JSON

current_version=$(jq -r '.pipeline.version' $NEW_JSON)
version=$(($current_version + 1))

echo "Setting pipeline version to $version"
jq --arg vn $version '.pipeline.version=$vn' $NEW_JSON > tmp.json && mv tmp.json $NEW_JSON

shift

opts=$(getopt \
  --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
  --name "$(basename "$0")" \
  --options "" \
  -- "$@"
)

eval set --$opts

while [[ $# -gt 0 ]]; do
  case "$1" in
    --branch)
        echo "Setting branch name to $2"
        TEST=$(jq -r '((.pipeline.stages[] | select(.name == "Source")).actions[] | select(.name == "Source")).configuration.Branch' $NEW_JSON)
        jq --arg br $2 '((.pipeline.stages[] | select(.name == "Source")).actions[] | select(.name == "Source")).configuration.Branch=$br' $NEW_JSON > tmp.json && mv tmp.json $NEW_JSON
        shift 2
        ;;
    --owner)
        echo "Setting owner name to $2"
        jq --arg own $2 '((.pipeline.stages[] | select(.name == "Source")).actions[] | select(.name == "Source")).configuration.Owner=$own' $NEW_JSON > tmp.json && mv tmp.json $NEW_JSON
        shift 2
        ;;
    --poll-for-source-changes)
        POLL_FOR_SOURCE_CHANGES=$2
        shift 2
        ;;
    --configuration)
        echo "Setting environment configuration to $2"
        ENV=$(jq -r --arg env $2 '(.pipeline.stages[] | select(.name=="QualityGate").actions[].configuration.EnvironmentVariables | fromjson)[] | .value=$env | tostring' $NEW_JSON)
        jq --arg env $ENV '(.pipeline.stages[].actions[].configuration | select(.EnvironmentVariables?)).EnvironmentVariables=$env' $NEW_JSON > tmp.json && mv tmp.json $NEW_JSON
        shift 2
        ;;
    *)
      break
      ;;
  esac
done

echo "Setting PollForSourceChanges to true"
jq --arg pfsc $POLL_FOR_SOURCE_CHANGES '((.pipeline.stages[] | select(.name == "Source")).actions[] | select(.name == "Source")).configuration.PollForSourceChanges=$pfsc' $NEW_JSON > tmp.json && mv tmp.json $NEW_JSON

echo "Updated pipeline definition: $NEW_JSON"