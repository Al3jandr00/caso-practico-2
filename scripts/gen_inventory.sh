#!/usr/bin/env bash
set -euo pipefail

IP=$(terraform -chdir=terraform output -raw public_ip)

cat > ansible/hosts.ini <<EOT
[vm]
$IP ansible_user=azureuser
EOT

echo "OK: inventario generado en ansible/hosts.ini con IP=$IP"
