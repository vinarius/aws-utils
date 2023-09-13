#/bin/bash

if [ -z "$AWS_PROFILE" ]; then
  echo "AWS_PROFILE is not set"
  exit 1
fi

if [ -z "$1" ]; then
  echo "Please provide a username"
  exit 1
fi

PASSWORD=$(aws secretsmanager get-random-password --password-length 20 --require-each-included-type --output text)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

aws iam create-user --user-name $1

if [ $? -ne 0 ]; then
  exit 1
fi

aws iam create-login-profile --user-name $1 --password $PASSWORD --password-reset-required

if [ $? -ne 0 ]; then
  exit 1
fi

aws iam add-user-to-group --user-name $1 --group-name admins
aws iam add-user-to-group --user-name $1 --group-name mfa

echo ""
echo "User: $1"
echo "Password: $PASSWORD"
echo "Sign in URL: https://$ACCOUNT_ID.signin.aws.amazon.com/console"
