#!/bin/bash
set -euo pipefail

# Automatizar fechar todas as portas da instância para internet (0.0.0.0/0)

INSTANCE_ID="i-1234567890abcdef0"
REGION="us-east-1"

echo "Buscando Security Groups da instância $INSTANCE_ID..."

SECURITY_GROUPS=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION" \
  --query 'Reservations[0].Instances[0].SecurityGroups[*].GroupId' \
  --output text)

for SG in $SECURITY_GROUPS; do
  echo "Processando Security Group: $SG"

  aws ec2 revoke-security-group-ingress \
    --group-id "$SG" \
    --region "$REGION" \
    --ip-permissions '[
      {
        "IpProtocol": "-1",
        "IpRanges": [{"CidrIp": "0.0.0.0/0"}]
      }
    ]' \
    2>/dev/null || echo "Nenhuma regra com 0.0.0.0/0 encontrada em $SG"
done

echo "Portas fechadas para internet com sucesso!"
