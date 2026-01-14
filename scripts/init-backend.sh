#! /usr/bin/env bash
set -euxo pipefail

BOOTSTRAP_DIR="backend-bootstrap"

# Check if bootstrap exists
if [ ! -d "$BOOTSTRAP_DIR" ]; then
    echo "Error: Bootstrap directory not found at $BOOTSTRAP_DIR"
    echo "Please run this from the project root directory"
    exit 1
fi

# Get bucket name and region from bootstrap
echo "Getting S3 bucket name from bootstrap..."
cd "$BOOTSTRAP_DIR"
BUCKET_NAME=$(terraform output -raw s3_bucket_name 2>/dev/null)
DYNAMODB_TABLE_NAME=$(terraform output -raw dynamodb_table_name 2>/dev/null)
REGION=$(terraform output -raw aws_region 2>/dev/null)

if [ -z "$BUCKET_NAME" ]; then
    echo "Error: Could not get bucket name from bootstrap"
    echo "Make sure you've run 'terraform apply' in $BOOTSTRAP_DIR first"
    exit 1
fi

if [ -z "$DYNAMODB_TABLE_NAME" ]; then
    echo "Warning: Could not get dynamodb table name from bootstrap, Exiting"
    exit 1
fi

if [ -z "$REGION" ]; then
    echo "Warning: Could not get region from bootstrap, Exiting"
    exit 1
fi

echo "Found bucket: $BUCKET_NAME"
echo "Region: $REGION"
cd - > /dev/null

# Initialize the module
echo "Initializing Terraform..."

terraform init \
  -backend-config="bucket=$BUCKET_NAME" \
  -backend-config="region=$REGION" \
  -backend-config="dynamodb_table=$DYNAMODB_TABLE_NAME"

echo "✓ Successfully initialized the terraform with S3 backend"
echo "  Bucket: $BUCKET_NAME"
echo "  Region: $REGION"
