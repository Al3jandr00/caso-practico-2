# Caso Práctico 2 (Terraform + Ansible + ACR + VM + Podman)

Este repositorio despliega infraestructura en Azure con Terraform y publica una imagen en Azure Container Registry (ACR).
Luego, usando Ansible, despliega esa imagen en una VM Linux con Podman y expone el servicio por HTTP (puerto 80).

## Estructura
- `terraform/`: infraestructura Azure (RG, VNet/Subnet, NSG, Public IP, NIC, VM, ACR)
- `ansible/`: despliegue del contenedor desde ACR a la VM con Podman
- `scripts/`: utilidades (generación de inventario desde Terraform)

## Requisitos
- Terraform
- Azure CLI autenticado (`az login`)
- Ansible
- Acceso SSH a la VM (usuario `azureuser`)
- Podman en la VM (lo instala Ansible si falta)

## 1) Terraform (crear infraestructura)
```bash
cd terraform
terraform init
terraform apply
```
## 2) Kubernetes (AKS) – despliegue de la imagen en clúster


Obtener credenciales:
```bash
az aks get-credentials -g rg-casopractico2-af -n aks-cp2-af --overwrite-existing
```

Ver estado:
```bash
kubectl get ns | grep cp2
kubectl -n cp2 get deploy web-cp2 -o wide
kubectl -n cp2 get pods -o wide
kubectl -n cp2 get svc web-cp2-svc -o wide
```
Acceso HTTP:
```bash
curl -I http://68.221.8.180
```
