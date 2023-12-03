#!/bin/bash

set -e # exit on error

BUCKET_NAME=$1
POLICY_NAME=${BUCKET_NAME}-access
USER_NAME=${BUCKET_NAME}-accessor
POLICY_ARN=$(aws iam list-policies --scope Local --query "Policies[?PolicyName == '${POLICY_NAME}'].Arn" | jq -r .[0])

aws iam detach-user-policy --user-name "$USER_NAME" --policy-arn "$POLICY_ARN"

aws iam delete-policy --policy-arn "$POLICY_ARN"

aws iam list-access-keys --user-name "${USER_NAME}" --query 'AccessKeyMetadata[].AccessKeyId' | jq -r .[] | xargs -I % aws iam delete-access-key --user-name "${USER_NAME}" --access-key-id %

aws iam delete-user --user-name "$USER_NAME"

aws s3 rb "s3://${BUCKET_NAME}"
