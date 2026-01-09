# AWS Ops Scripts 🚀

[![Bash](https://img.shields.io/badge/Bash-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=FF9900)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Active-green?style=for-the-badge)](#)

## 📋 Descrição

Coleção de **scripts Bash profissionais** para automação de infraestrutura na AWS. Desenvolvido para facilitar tarefas comuns de Cloud Support / DevOps com foco em **EC2, Security Groups e hardening de segurança**.

### 🎯 Casos de Uso
- ✅ Provisionamento rápido de instâncias EC2
- ✅ Configuração automatizada de Apache/web servers
- ✅ Gerenciamento de Security Groups
- ✅ Hardening e segurança de instâncias
- ✅ Integração com AWS CLI

---

## 📦 Scripts Disponíveis

### 1️⃣ `create_ec2_ubuntu.sh` - Criar Instância EC2

**Descrição:** Cria uma nova instância EC2 com Ubuntu LTS na AWS

**O que faz:**
```
✓ Cria instância EC2 com AMI Ubuntu
✓ Aguarda instância entrar em estado 'running'
✓ Retorna IP público da instância
✓ Configura permissões de acesso via IAM
```

**Como usar:**
```bash
./create_ec2_ubuntu.sh
```

**Variáveis obrigatórias (edite no script):**
- `IMAGE_ID`: ID da AMI Ubuntu para sua região
- `INSTANCE_TYPE`: Tipo de instância (ex: t2.micro, t3.small)
- `KEY_NAME`: Nome da key pair existente na AWS
- `SUBNET_ID`: ID da subnet (opcional)

**Saída esperada:**
```
Instância criada com sucesso!
Instance ID: i-0123456789abcdef0
IP Público: 203.0.113.42
```

---

### 2️⃣ `setup_apache.sh` - Configurar Apache2

**Descrição:** Provisiona e configura Apache2 em uma instância EC2 com Ubuntu

**O que faz:**
```
✓ Atualiza pacotes do SO
✓ Instala Apache2
✓ Ativa o serviço automaticamente
✓ Cria página HTML de teste
✓ Valida instalação com curl
```

**Como usar:**
```bash
# Via SSH na instância
ssh -i sua-key.pem ubuntu@IP_DA_INSTANCIA
./setup_apache.sh
```

**Ou como user-data (ao criar instância):**
```bash
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --user-data file://setup_apache.sh
```

**Validação:**
```bash
curl http://localhost
# Esperado: página HTML com informações da instância
```

---

### 3️⃣ `close_ports.sh` - Fechar Portas de Security Group

**Descrição:** Remove regras de entrada abertas para internet (0.0.0.0/0) em um Security Group

**O que faz:**
```
✓ Obtém regras do Security Group
✓ Identifica portas abertas para 0.0.0.0/0
✓ Remove cada regra processada
✓ Registra ações realizadas
```

**Como usar:**
```bash
./close_ports.sh
```

**Variáveis obrigatórias:**
- `INSTANCE_ID`: ID da instância EC2 (ex: i-0123456789abcdef0)
- `REGION`: Região da AWS (ex: us-east-1)

**Exemplo com parâmetros:**
```bash
INSTANCE_ID="i-0c123456789abcdef" REGION="us-east-1" ./close_ports.sh
```

**Saída:**
```
Security Group: sg-0123456789abcdef0
---
Fechando porta 80... ✓
Fechando porta 443... ✓
Fechando porta 22... ✓
Total: 3 regras removidas
```

---

## 🔐 Segurança & Best Practices

### ⚠️ Pré-requisitos
1. **AWS CLI** instalado e configurado
   ```bash
   aws configure
   ```
2. **IAM Permissions** necessárias:
   ```
   ec2:RunInstances
   ec2:DescribeInstances
   ec2:DescribeSecurityGroups
   ec2:RevokeSecurityGroupIngress
   ```
3. **Key Pair** criada na AWS
4. **Bash 4.0+** instalado localmente

### 🛡️ Recomendações de Segurança

✅ **Fazer:**
- Use IAM roles ao invés de credenciais hardcoded
- Sempre revise o Security Group antes de remover regras
- Mantenha backups antes de executar scripts em produção
- Use `--dry-run` antes de aplicar mudanças
- Implemente logging e auditoria

❌ **Não fazer:**
- Não execute scripts com privilégios `sudo` desnecessários
- Não coloque secrets (passwords, tokens) no código
- Não abra portas para 0.0.0.0/0 sem justificativa
- Não ignore mensagens de erro dos scripts

---

## 🚀 Quick Start

### 1. Clone o repositório
```bash
git clone https://github.com/LucianoHMG/aws-ops-scripts.git
cd aws-ops-scripts
```

### 2. Configure permissões de execução
```bash
chmod +x *.sh
```

### 3. Configure suas variáveis
```bash
# Edite o script para sua região e tipo de instância
vim create_ec2_ubuntu.sh
```

### 4. Execute
```bash
./create_ec2_ubuntu.sh
```

---

## 📊 Exemplos Reais

### Exemplo 1: Criar instância e configurar Apache
```bash
# 1. Criar instância
./create_ec2_ubuntu.sh
# Output: IP: 203.0.113.42

# 2. SSH e setup Apache
ssh -i ~/.aws/my-key.pem ubuntu@203.0.113.42
./setup_apache.sh

# 3. Testar
curl http://203.0.113.42
```

### Exemplo 2: Fechar portas desnecessárias
```bash
# Identificar SG aberto
aws ec2 describe-security-groups --query 'SecurityGroups[?IpPermissions[?IpRanges[?CidrIp==`0.0.0.0/0`]]]'

# Fechar portas
INSTANCE_ID="i-0c123456" REGION="us-east-1" ./close_ports.sh
```

---

## 🧪 Testes

### Testar localmente (sem AWS)
```bash
# Validar sintaxe Bash
bash -n script.sh

# Executar com verbose
bash -x script.sh
```

### Testar em EC2
```bash
# Listar últimas 5 instâncias
aws ec2 describe-instances --max-results 5 \
  --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,IP:PublicIpAddress}'
```

---

## 📝 Logging & Auditoria

Os scripts registram suas ações em:
```
/var/log/aws-ops-scripts.log
```

Para monitorar em tempo real:
```bash
tail -f /var/log/aws-ops-scripts.log
```

---

## 🤝 Contribuindo

1. Faça um Fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## ✅ Roadmap / TODO

- [ ] Adicionar suporte a RDS automation
- [ ] Implementar testes automatizados com bats
- [ ] Criar GitHub Actions para CI/CD
- [ ] Adicionar suporte a CloudFormation
- [ ] Documentação em vídeo (YouTube)
- [ ] Integração com Terraform

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 👤 Autor

**Luciano Girão**
- GitHub: [@LucianoHMG](https://github.com/LucianoHMG)
- LinkedIn: [lucianogirão](https://www.linkedin.com/in/lucianogirão)
- Email: lucianowtp@gmail.com

### 📚 Recursos Adicionais
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [AWS CLI Reference](https://docs.aws.amazon.com/cli/latest/reference/ec2/)
- [Bash Best Practices](https://mywiki.wooledge.org/BashGuide)
- [AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)

---

## ⭐ Se este projeto foi útil, dê uma star! ⭐

**Last Updated:** 2026-01-08  
**Status:** ✅ Em Desenvolvimento Ativo
