#!/usr/bin/env bash
if [[ -z $5 ]]; then
    echo "Usage: . get-access-token.sh <idcs-url> <idcs-client-id> <idcs-client-secret> <req_scope> <apics-user-name> <apics-user-password>"
else
    export IDCS_URL=$1
    export IDCS_CLIENT_ID=$2
    export IDCS_CLIENT_SECRET=$3
    export REQ_SCOPE=$4
    export APICS_USER=$5
    export APICS_PWD=$6
fi

payload="grant_type=password&scope=${REQ_SCOPE}&username=${APICS_USER}&password=${APICS_PWD}"
url="${IDCS_URL}/oauth2/v1/token"
echo "curl -s -X POST -u ${IDCS_CLIENT_ID}:${IDCS_CLIENT_SECRET} -d ${payload} ${url}" 
token=$(curl -s -X POST -u "${IDCS_CLIENT_ID}:${IDCS_CLIENT_SECRET}" -d "${payload}" "${url}" | jq -r ".access_token")
echo "***************GENERATING TOKEN ************"

if [[ -z $token ]] || [[ ! -z $(grep "parse error" <<< "${token}") ]] || [[ "${token}" == "null" ]]; then
    echo "Error in obtaining access token."
else
    export ACCESS_TOKEN=$token
    echo $ACCESS_TOKEN
fi
