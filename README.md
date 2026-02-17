# Caso Práctico 2  
## Terraform + ACR + VM + Ansible + AKS + Persistencia en Kubernetes

Este proyecto implementa un despliegue completo en Microsoft Azure utilizando Infraestructura como Código, contenedores y Kubernetes.

---

# Objetivo del Proyecto

El objetivo es diseñar y desplegar una arquitectura completa en Azure que permita:

- Crear infraestructura automáticamente con Terraform
- Construir y publicar una imagen Docker en Azure Container Registry (ACR)
- Desplegar la aplicación en:
  - Una máquina virtual Linux usando Ansible + Podman
  - Un clúster Kubernetes (AKS)
- Exponer la aplicación públicamente
- Implementar almacenamiento persistente en Kubernetes
- Aplicar buenas prácticas de DevOps e Infraestructura como Código

---

# Arquitectura General

## Infraestructura creada con Terraform

Terraform crea los siguientes recursos en Azure:

- Resource Group
- Virtual Network (VNet)
- Subnet
- Network Security Group (NSG)
- Public IP
- Network Interface
- Máquina Virtual Linux
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS)
- Asignación de rol `AcrPull` para permitir que AKS acceda al ACR

---

# Estructura del Repositorio

```
terraform/
  main.tf
  vm.tf
  acr.tf
  aks.tf
  outputs.tf
  k8s/
    web-cp2-deploy.yaml
    web-cp2-svc.yaml
    web-cp2-pvc.yaml

ansible/
scripts/
README.md
```

---

# Requisitos

- Terraform
- Azure CLI (`az login`)
- Docker
- Ansible
- kubectl
- Acceso SSH a la VM

---

# Creación de Infraestructura con Terraform

Entrar en la carpeta terraform:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Obtener la IP pública de la VM:

```bash
terraform output -raw public_ip
```

---

# Construcción y Publicación de Imagen en ACR

Login en el registro:

```bash
az acr login --name acrcp2af2026
```

Construir imagen:

```bash
docker build -t web-cp2:1.0 .
```

Etiquetar imagen para ACR:

```bash
docker tag web-cp2:1.0 acrcp2af2026.azurecr.io/web-cp2:1.0
```

Subir imagen al registro:

```bash
docker push acrcp2af2026.azurecr.io/web-cp2:1.0
```

---

# Despliegue en VM con Ansible + Podman

Desde la carpeta ansible:

```bash
ansible-playbook -i inventory playbook.yml
```

Verificar acceso:

```bash
curl -I http://IP_PUBLICA_VM
```

---

# Configuración de AKS

Obtener credenciales del clúster:

```bash
az aks get-credentials -g rg-casopractico2-af -n aks-cp2-af --overwrite-existing
```

Verificar nodos:

```bash
kubectl get nodes -o wide
```

---

# Despliegue en Kubernetes

Crear namespace:

```bash
kubectl create namespace cp2
```

Aplicar recursos:

```bash
kubectl apply -f terraform/k8s/web-cp2-pvc.yaml
kubectl apply -f terraform/k8s/web-cp2-deploy.yaml
kubectl apply -f terraform/k8s/web-cp2-svc.yaml
```

Verificar estado:

```bash
kubectl -n cp2 get deploy,po,svc,pvc -o wide
```

---

# Persistencia en Kubernetes

Se utiliza un PersistentVolumeClaim de 1Gi.

El Deployment incluye un initContainer que:

- Comprueba si existe `index.html`
- Si no existe, copia el contenido inicial
- Evita el problema del directorio `lost+found`
- Garantiza idempotencia

Comprobar contenido dentro del pod:

```bash
kubectl -n cp2 exec -it deploy/web-cp2 -- ls -la /usr/share/nginx/html
```

Eliminar pod para validar persistencia:

```bash
kubectl -n cp2 delete pod -l app=web-cp2
```

El contenido debe mantenerse tras la recreación del pod.

---

# Acceso Público

Obtener IP externa del servicio:

```bash
kubectl -n cp2 get svc web-cp2-svc
```

Acceso vía navegador:

```
http://IP_EXTERNA
```

Comprobación por consola:

```bash
curl -I http://IP_EXTERNA
```

---

# Buenas Prácticas Aplicadas

- Infraestructura como Código (Terraform)
- Separación Infraestructura / Aplicación
- Uso de ACR privado
- Principio de menor privilegio (AcrPull)
- Persistencia en Kubernetes
- InitContainer idempotente
- Control de versiones con Git
- Despliegue reproducible

---

# Limpieza del Entorno

Para eliminar todos los recursos:

```bash
cd terraform
terraform destroy
```

---

# Resultado Final

Aplicación Nginx:

- Desplegada en VM con Podman
- Desplegada en AKS
- Expuesta públicamente
- Con almacenamiento persistente
- Imagen alojada en ACR privado
- Infraestructura completamente automatizada y reproducible
