#!/bin/bash

set -e # exit on error

BUCKET_NAME=$1
POLICY_NAME="${BUCKET_NAME}-access"
USER_NAME="${BUCKET_NAME}-accessor"

cat >/tmp/joplin-policy.json <<EOL
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "S3ObjectsAllJoplin",
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:GetObject",
				"s3:RestoreObject",
				"s3:ListBucket",
				"s3:DeleteObject"
			],
			"Resource": [
				"arn:aws:s3:::*/*",
				"arn:aws:s3:::${BUCKET_NAME}"
			]
		}
	]
}
EOL

if ! which jq 2> /dev/null ; then
	echo "need to install jq";
fi

if ! which aws 2> /dev/null ; then
	echo "need to install aws cli";
fi

aws s3 mb "s3://$BUCKET_NAME"

POLICY_JSON=$(aws iam create-policy --policy-document file:///tmp/joplin-policy.json --policy-name "$POLICY_NAME")

POLICY_ARN=$(echo "$POLICY_JSON" | jq -r '.Policy.Arn')

aws iam create-user --user-name "${USER_NAME}"

aws iam attach-user-policy --user-name "$USER_NAME" --policy-arn "$POLICY_ARN"

ACCESS_JSON=$(aws iam create-access-key --user-name "$USER_NAME")

ACCESS_KEY=$(echo "$ACCESS_JSON" | jq -r .AccessKey.AccessKeyId)

SECRET_KEY=$(echo "$ACCESS_JSON" | jq -r .AccessKey.SecretAccessKey)

REGION=$(aws s3api get-bucket-location --bucket "$BUCKET_NAME" --output text)

echo "==== JOPLIN SYNC SETTINGS ==="
echo "Sync Target: S3"
echo "Bucket: ${BUCKET_NAME}"
echo "URL: https://s3.${REGION}.amazonaws.com"
echo "Region: ${REGION}"
echo "Access Key: ${ACCESS_KEY}"
echo "Secret Key: ${SECRET_KEY}"
