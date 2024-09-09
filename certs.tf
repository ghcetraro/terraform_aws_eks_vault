# Create Private Key for CA
resource "tls_private_key" "cm_ca_private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
#
# Create Private CA certificate
resource "tls_self_signed_cert" "cm_ca_cert" {
  private_key_pem   = tls_private_key.cm_ca_private_key.private_key_pem
  is_ca_certificate = true
  subject {
    country             = var.vault.country
    province            = var.vault.province
    locality            = var.vault.locality
    common_name         = var.vault.common_name
    organization        = var.vault.organization
    organizational_unit = var.vault.organizational_unit
  }
  validity_period_hours = var.vault.validity_period_hours_ca
  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}
#
# Create private key for server certificate 
resource "tls_private_key" "cm_internal" {
  algorithm = "RSA"
}
# Create CSR for for server certificate 
resource "tls_cert_request" "cm_internal_csr" {
  #
  private_key_pem = tls_private_key.cm_internal.private_key_pem
  dns_names       = local.vault_dns
  ip_addresses    = local.vault_ip_addresses
  #
  subject {
    common_name = var.vault.common_name
    #
    country             = var.vault.country
    province            = var.vault.province
    locality            = var.vault.locality
    organization        = var.vault.organization
    organizational_unit = var.vault.organizational_unit
  }
}
#
# Sign Server Certificate by Private CA 
resource "tls_locally_signed_cert" "cm_internal" {
  # CSR by the development servers
  cert_request_pem = tls_cert_request.cm_internal_csr.cert_request_pem
  # CA Private key 
  ca_private_key_pem = tls_private_key.cm_ca_private_key.private_key_pem
  # CA certificate
  ca_cert_pem           = tls_self_signed_cert.cm_ca_cert.cert_pem
  validity_period_hours = var.vault.validity_period_hours_cert
  #
  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]
}
#
resource "kubernetes_secret" "vaut" {
  metadata {
    name      = var.vault.secret_name
    namespace = kubernetes_namespace.vault.metadata[0].name
  }
  data = {
    "vault.ca"  = tls_self_signed_cert.cm_ca_cert.cert_pem
    "vault.crt" = tls_locally_signed_cert.cm_internal.cert_pem
    "vault.key" = tls_private_key.cm_internal.private_key_pem
  }
  type = "Opaque"
  #
  depends_on = [
    kubernetes_namespace.vault,
  ]
}
#
##################################
# user for debug only
#resource "local_file" "cloudmanthan_ca_key" {
#  content  = tls_private_key.cm_ca_private_key.private_key_pem
#  filename = "${path.module}/certs/cloudmanthanCA.key"
#}
##
#resource "local_file" "cloudmanthan_ca_cert" {
#  content  = tls_self_signed_cert.cm_ca_cert.cert_pem
#  filename = "${path.module}/certs/cloudmanthanCA.cert"
#}
##
#resource "local_file" "cm_internal_key" {
#  content  = tls_private_key.cm_internal.private_key_pem
#  filename = "${path.module}/certs/dev.cloudmanthan.key"
#}
##
#resource "local_file" "cm_internal_cert" {
#  content  = tls_locally_signed_cert.cm_internal.cert_pem
#  filename = "${path.module}/certs/dev.cloudmanthan.cert"
#}