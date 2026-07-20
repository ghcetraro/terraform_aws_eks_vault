# Uso y despliegue

## Descripción

HashiCorp Vault en alta disponibilidad sobre EKS, storage DynamoDB, TLS y DNS — con Terraform

Módulo Terraform que despliega Vault HA en EKS con DynamoDB como storage, KMS, secrets, Route53 y certificados.

## Requisitos

- Terraform 1.x
- AWS CLI con permisos adecuados
- Para módulos EKS: cluster existente y acceso de API

## Variables

Usá siempre la plantilla **`terraform.tfvars.example`**. No subas `terraform.tfvars` ni el state.

### Módulo raíz del repo

```bash
# desde la raíz
cp terraform.tfvars.example terraform.tfvars
# Completar variables y locals según tu cuenta/cluster

aws sso login --profile <tu-profile>   # o credenciales equivalentes
terraform init
terraform plan
terraform apply
```


## Post-apply

Revisá outputs del módulo y recursos en la consola AWS / `kubectl` según corresponda.

## Seguridad

Ver [SECURITY.md](../SECURITY.md).
