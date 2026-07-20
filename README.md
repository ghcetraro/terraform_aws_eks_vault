# Vault HA en EKS (DynamoDB storage)

[![License: MIT](https://img.shields.io/github/license/ghcetraro/terraform_aws_eks_vault)](LICENSE)
[![Terraform](https://img.shields.io/badge/terraform-1.x-7B42BC.svg)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-compatible-FF9900.svg)](https://aws.amazon.com/)
[![CI](https://github.com/ghcetraro/terraform_aws_eks_vault/actions/workflows/ci.yml/badge.svg)](https://github.com/ghcetraro/terraform_aws_eks_vault/actions/workflows/ci.yml)

**HashiCorp Vault en alta disponibilidad sobre EKS, storage DynamoDB, TLS y DNS — con Terraform**

---

## El problema

Montar Vault HA en EKS implica KMS, DynamoDB, roles IRSA, certs y DNS. Hacerlo a mano es frágil y poco repetible.

## La solución

Módulo Terraform que despliega Vault HA en EKS con DynamoDB como storage, KMS, secrets, Route53 y certificados.

```mermaid
flowchart TB
  TF[Terraform] --> EKS[EKS Vault pods]
  EKS --> DDB[(DynamoDB)]
  EKS --> KMS[KMS]
  EKS --> SM[Secrets Manager]
  DNS[Route53] --> EKS
```

---

## Características

| Área | Detalle |
|------|---------|
| **HA** | Vault en EKS con storage DynamoDB |
| **KMS** | Cifrado y unseal preparado para AWS |
| **IRSA / roles** | Permisos IAM alineados al cluster |
| **DNS + TLS** | Route53 y certificados ACM/certs |
| **IaC** | Despliegue reproducible con Terraform |

---

## Limitaciones y disclaimer

- Pensado como **punto de partida / referencia**: revisá roles IAM, redes y secretos antes de producción.
- Requiere **credenciales AWS** (recomendado SSO) y, en módulos EKS, acceso al cluster (kubeconfig / exec).
- Completá `locals` y variables según tu cuenta; los ejemplos usan valores ficticios.
- Software open source “as is” — probá primero en un ambiente no productivo.

---

## Stack

Terraform · EKS · Vault · DynamoDB · KMS · Route53

---

## Inicio rápido

### Requisitos

- Terraform CLI 1.x
- AWS CLI configurado (`aws sso login` o credenciales)
- Permisos de administración en la cuenta / cluster según el módulo

### Configuración

```bash
# En cada módulo: copiá la plantilla (no commitear terraform.tfvars)
cp terraform.tfvars.example terraform.tfvars
```

Valores de ejemplo: `terraform.tfvars.example`

### Apply

```bash
cp terraform.tfvars.example terraform.tfvars
# Editar valores (cuenta, región, cluster, etc.)

terraform init
terraform plan
terraform apply
```

---

## Documentación

- [Uso y despliegue](docs/uso.md)
- [Presentación / LinkedIn](docs/PRESENTACION.md)
- [Speech para LinkedIn](docs/speech-linkedin.md)
- [Changelog](CHANGELOG.md)
- [Contribuir](CONTRIBUTING.md)
- [Seguridad](SECURITY.md)

---

## Seguridad

**No commitees** `terraform.tfvars`, state, claves ni tokens. Usá `*.tfvars.example` como plantilla.

Ver [SECURITY.md](SECURITY.md).

---

## Licencia

[MIT](LICENSE) — Copyright (c) Gabriel Cetraro

---

## Autor

Proyecto open source de **Gabriel Cetraro** — automatización de infraestructura, AWS, Kubernetes y observabilidad.

Si te resulta útil, ⭐ en GitHub ayuda a darle visibilidad.
