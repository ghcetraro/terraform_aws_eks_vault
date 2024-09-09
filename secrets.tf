locals {
  parameter_store_secrets = merge(
    {
      vault_server_ca  = tls_self_signed_cert.cm_ca_cert.cert_pem
      vault_server_crt = tls_locally_signed_cert.cm_internal.cert_pem
      vault_server_key = tls_private_key.cm_internal.private_key_pem
    }
  )
}

# Parameter Store Secrets
module "vault_secrets" {
  source  = "./secrets"
  secrets = local.parameter_store_secrets
  tags    = local.tags
  #
  depends_on = [
    kubernetes_secret.vaut
  ]
}

resource "aws_secretsmanager_secret" "vault" {
  name                    = "vault-server-initial-token"
  recovery_window_in_days = "30"
  tags                    = local.tags
}