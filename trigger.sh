#!/bin/bash

# Sends an event to another repository. The receiver side can detect this by
# creating a hook for "workflow_dispatch" event in your Github Actions
# 
# https://docs.github.com/en/free-pro-team@latest/rest/reference/actions#create-a-workflow-dispatch-event
# https://docs.github.com/en/free-pro-team@latest/developers/webhooks-and-events/webhook-events-and-payloads#workflow_dispatch

set -e

if [[ -z "$TRIGGER_USERNAME" ]]; then
	echo "TRIGGER_USERNAME (username for Github API calls) environment variable is required"

	exit 1
fi

if [[ -z "$TRIGGER_TOKEN" ]]; then
	echo "TRIGGER_TOKEN (personal access token for Github API calls) environment variable is required"
	exit 1
fi

if [[ -z "$DST_REPO" ]]; then
	echo "DST_REPO (format: "username/reponame") environment variable is required"
	exit 1
fi

if [[ -z "$DST_WORKFLOW" ]]; then
	echo "DST_WORKFLOW (i.e. name of the workflow file) environment variable is required"
	exit 1
fi

curl -XPOST \
	-u "$TRIGGER_USERNAME:$TRIGGER_TOKEN" \
	-H "Accept: application/vnd.github.everest-preview+json" \
	-H "Content-Type: application/json" \
	--data '{"ref": "main"}' \
	https://api.github.com/repos/$DST_REPO/actions/workflows/$DST_WORKFLOW/dispatches 

