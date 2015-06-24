#!/bin/bash -x
#. ./build-esen.sh

# set deug mode
if [ -n "$WERCKER_WERCKER_TRIGGERBUILD_DEBUG" ]
then
    set -x
fi

# ensure we have a token
if [ -z "$WERCKER_WERCKER_TRIGGERBUILD_TOKEN" ]
then
    fail "missing required option 'token'"
fi

# set app id
if [ -z "$WERCKER_WERCKER_TRIGGERBUILD_APPLICATION_ID" ]
then
    fail "missing required option option 'application_id'"
fi
JSON="\"applicationId\": \"$WERCKER_WERCKER_TRIGGERBUILD_APPLICATION_ID\""

# set optional branch
if [ -n "$WERCKER_WERCKER_TRIGGERBUILD_BRANCH" ]
then
	JSON="$JSON, \"branch\": \"$WERCKER_WERCKER_TRIGGERBUILD_BRANCH\""

	# set optional commit hash, but only if we have a branch
	if [ -n "$WERCKER_WERCKER_TRIGGERBUILD_COMMIT_HASH" ]
	then
		JSON="$JSON, \"commit\": \"$WERCKER_WERCKER_TRIGGERBUILD_COMMIT_HASH\""
	fi
fi

# set optional message
if [ -n "$WERCKER_WERCKER_TRIGGERBUILD_MESSAGE" ]
then
	JSON="$JSON, \"message\": \"$WERCKER_WERCKER_TRIGGERBUILD_MESSAGE\""
fi

info "Requesting build"
RET=$( curl -qSsw '\n%{http_code}' \
	-H 'Content-Type: application/json' \
	-H  "Authorization: Bearer $WERCKER_WERCKER_TRIGGERBUILD_TOKEN" \
	-X POST -d {"$JSON"} \
	--silent \
	https://app.wercker.com/api/v3/builds) 2>/dev/null
STATUS=$(echo "$RET" | tail -n1 )
RET=$(echo "$RET" | head -n-1)
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [[ $STATUS -ne "200" ]]
then
	MSG=$(echo $RET | $DIR/JSON.sh |  awk '$1 ~ /message/ {$1=""; print $0}')
    fail "Wercker trigger build failed: $MSG"
else
	URL=$(echo $RET | $DIR/JSON.sh |  awk '$1 ~ /URL/ {$1=""; print $0}')
    success "Wercker trigger build has been requested succesfully"
	success "View the status of the buld at: $URL"
fi
