# aws-ops-scripts

Scripts Bash para automação de instâncias EC2 e gerenciamento de Security Groups na AWS. Desenvolvido para facilitar tarefas de Cloud Support / SysOps com enfoque em troubleshooting e operação.

## 📄 Scripts Disponíveis

### 1. `create_ec2_ubuntu.sh`
Cria uma instância EC2 com Ubuntu LTS na AWS.

**O que faz:**
- Cria uma instância EC2 com imagem Ubuntu
- Aguarda a instancia estar em estado `running`
- Retorna o IP público da instância

**Como usar:**
```bash
./create_ec2_ubuntu.sh
```

**Variáveis obrigatórias (edite o script):**
- `IMAGE_ID`: ID da AMI Ubuntu (ajuste para sua região)
- `INSTANCE_TYPE`: Tipo de instancia (ex: t2.micro)
- `KEY_NAME`: Nome da Key Pair já criada na sua região
- `SECURITY_GROUP`: ID do Security Group (sg-xxxxxx)
- `REGION`: Região da AWS (ex: us-east-1)

**Pré-requisitos:**
- AWS CLI configurado (`aws configure`)
- Permissões IAM: `ec2:RunInstances`, `ec2:DescribeInstances`, `ec2:WaitUntilInstanceRunning`

---

### 2. `setup_apache.sh`
Proviciona Apache2 em uma instancia EC2 com Ubuntu.

**O que faz:**
- Atualiza pacotes do SO
- Instala Apache2
- Ativa o serviço automaticamente
- Cria página HTML de teste

**Como usar:**
Via SSH na instancia ou como user-data:
```bash
sudo ./setup_apache.sh
```

**Ou, integrando ao `create_ec2_ubuntu.sh`:**
Adicione no comando `run-instances`:
```bash
--user-data file://setup_apache.sh
```

**Pré-requisitos:**
- Acesso root (ou sudo)
- Instancia Ubuntu/Debian

---

### 3. `close_ports.sh`
Fecha todas as portas abertas para internet (0.0.0.0/0) nos Security Groups de uma instancia.

**O que faz:**
- Obtém os Security Groups ligados à instancia
- Remove regras de entrada (inbound) que permitam acesso de qualquer IP (0.0.0.0/0)
- Registra cada SG processado

**Como usar:**
```bash
./close_ports.sh
```

**Variáveis obrigatórias (edite o script):**
- `INSTANCE_ID`: ID da instancia EC2 (i-xxxxxx)
- `REGION`: Região da AWS

**Pré-requisitos:**
- AWS CLI configurado
- Permissões IAM: `ec2:DescribeInstances`, `ec2:RevokeSecurityGroupIngress`

**⚠️ AVISO DE SEGURANÇA:**
Este script remove **todas** as regras com `0.0.0.0/0`. Se sua única forma de acesso é SSH com essa regra aberta, você perderá acesso. Use em:
- Ambiente de lab
- Instâncias com outro caminho de acesso (Session Manager, bastion, etc.)
- Antes de qualquer deploy em produção, revise com seu time

---

## 🚧 Pré-requisitos Globais

### 1. AWS CLI
Instale: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Configure:
```bash
aws configure
```

Valide:
```bash
aws sts get-caller-identity
```

### 2. Permissões IAM Mínimas
Seu usuário/role precisa de:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:DescribeInstances",
        "ec2:DescribeSecurityGroups",
        "ec2:RevokeSecurityGroupIngress"
      ],
      "Resource": "*"
    }
  ]
}
```

### 3. Bash 4+
Valide:
```bash
bash --version
```

---

## 💫 Exemplos de Uso

### Criar instancia e provisionar Apache
```bash
# 1) Editar create_ec2_ubuntu.sh com os dados corretos
nano create_ec2_ubuntu.sh

# 2) Criar a instância
./create_ec2_ubuntu.sh
# Saída: IP Público da instância

# 3) Conectar via SSH e rodar setup
ssh -i sua-chave.pem ubuntu@<PUBLIC_IP>
sudo ./setup_apache.sh

# 4) Testar
curl http://<PUBLIC_IP>
```

### Fechar portas de uma instancia
```bash
# 1) Obter o ID da instancia
aws ec2 describe-instances --region us-east-1 --query 'Reservations[0].Instances[0].InstanceId' --output text

# 2) Editar close_ports.sh com o INSTANCE_ID
nano close_ports.sh

# 3) Executar (CUIDADO: perderá acesso se SSH era 0.0.0.0/0)
./close_ports.sh
```

---

## 💁 Troubleshooting

### Erro: "UnauthorizedOperation"
Causa: AWS CLI não tem permissões.
Solução: Confirme que o usuário tem as IAM policies corretas.

### Erro: "You do not have permission to use the key pair"
Causa: Key Pair informada não existe na região.
Solução: Confirme o nome e a região.

### Perdi acesso SSH após rodar `close_ports.sh`
Causa: Script removeu a regra de SSH `0.0.0.0/0`.
Solução: Use o console AWS ou Session Manager para restaurar a regra de SG.

---

## 🚀 Próximo Passos

- [ ] Testar scripts em ambiente de lab
- [ ] Adicionar suporte para Amazon Linux 2
- [ ] Implementar dry-run mode
- [ ] Criar wrapper para múltiplas regiões
- [ ] Adicionar logging estruturado

---

## 📚 Licença

MIT - Sinta-se livre para usar, modificar e distribuir.

---

## 🤛 Contribuições

Sugestões? Issues? Pull Requests?
Abra uma issue ou envie seu feedback!

**Desenvolvido para Cloud Support / SysOps Engineers em transição.**
