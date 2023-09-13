#!/bin/bash

if [ -z "$AWS_PROFILE" ]; then
  echo "AWS_PROFILE is not set"
  exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

aws iam create-group --group-name admins
aws iam create-group --group-name mfa
aws iam create-policy --policy-name mfa --policy-document file://mfa-policy.json
aws iam attach-group-policy --group-name mfa --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/mfa
aws iam attach-group-policy --group-name admins --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
