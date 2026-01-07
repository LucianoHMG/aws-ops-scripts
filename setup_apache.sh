#!/bin/bash

# Script para provisionar Apache2 em uma instância EC2 com Ubuntu

set -e

echo "Atualizando pacotes do sistema..."
apt-get update
apt-get upgrade -y

echo "Instalando Apache2..."
apt-get install -y apache2

echo "Habilitando serviço Apache..."
systemctl enable apache2
systemctl start apache2

echo "Criando página HTML de teste..."
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Bem-vindo ao Apache</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
    </style>
</head>
<body>
    <h1>Apache está rodando!</h1>
    <p>Instância criada e configurada com sucesso.</p>
    <p>Hostname: $(hostname)</p>
    <p>IP Local: $(hostname -I)</p>
</body>
</html>
EOF

echo "Verificando status do Apache..."
systemctl status apache2

echo "Configuração concluída com sucesso!"
