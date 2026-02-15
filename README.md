# Caso Práctico 2 (Terraform + Ansible + ACR + VM + Podman)

## Estructura
- `terraform/`: infraestructura Azure (RG, VNet/Subnet, NSG, Public IP, NIC, VM, ACR)
- `ansible/`: despliegue del contenedor desde ACR a la VM con Podman

## Requisitos
- Terraform
- Azure CLI autenticado (`az login`)
- Ansible
- Acceso SSH a la VM (usuario `azureuser`)
- Podman en la VM (Ansible lo instala si falta)

## 1) Terraform (crear infraestructura)

```bash
cd terraform
terraform init
terraform apply

