#!/bin/bash
set -euo pipefail

# Criar uma instância EC2 na AWS usando o AWS CLI

REGION="us-east-1"
IMAGE_ID="ami-XXXXXXXX"          # Ubuntu LTS da sua região
INSTANCE_TYPE="t2.micro"
KEY_NAME="sua-chave-pem"
SECURITY_GROUP="sg-xxxxxxxxx"

echo "Criando instância na região ${REGION}..."

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$IMAGE_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP" \
  --count 1 \
  --region "$REGION" \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Instância criada: $INSTANCE_ID"

aws ec2 wait instance-running \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION"

echo "Instância em execução!"

PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "IP Público: $PUBLIC_IP"
