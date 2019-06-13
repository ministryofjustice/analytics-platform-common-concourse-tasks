#!/bin/bash

pip install iam_builder
echo '[]' | jq -S . > policies/list.json
cat repos/list.txt
cat repos/list.txt | while read line
do
  {
    git clone https://moj-analytical-services:${GITHUB_TOKEN}@github.com/moj-analytical-services/${line}.git
    if [[ -f ${line}/iam_config.yaml ]] && [[ ! -f ${line}/iam_policy.json ]]; then
      echo 'Building iam_policy.json from iam_config.yaml'
      iam_builder -c ${line}/iam_config.yaml -o ${line}/iam_policy.json
    fi
    if [[ -f ${line}/deploy.json ]] && [[ -f ${line}/iam_policy.json ]]; then
      role=$(cat ${line}/deploy.json | jq -r '.role_name')
      policy=$(cat ${line}/iam_policy.json | jq -r .)
      rm -rf ${line}
      policies=$(cat policies/list.json | jq --argjson policy "$policy" --arg role "$role"  --arg app_name "$line" '. += [{role: $role, policy: $policy, app_name: $app_name}]')
      echo ${policies} | jq -S . > policies/list.json
    fi
  } || {
    echo 'No repo'
  }
done
cat policies/list.json | jq -S .
