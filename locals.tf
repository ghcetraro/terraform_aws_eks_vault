locals {
  app_name_dashed = "${var.customer}-${var.environmet}"
  #
  aws_profile = "${var.customer}-${var.environmet}"
  #
  role_name = "${local.app_name_dashed}-vault"
  #
  tags = {
    application_name = local.app_name_dashed
    environment      = var.environment
    provisioner      = "terraform"
  }
  #
  vault_dns = [
    "vault",
    "vault.vault",
    "vault.vault.svc",
    "vault.vault.svc.cluster.local",
  ]
  #
  vault_ip_addresses = [
    "127.0.0.1",
  ]
  #
  dns = {
    public_zone_id  = " " # to fill
    private_zone_id = " " # to fill
  }
  #
  acm_certificate_arn_public = " "  # to fill
  #
  eks = {
    id                         = " "  # to fill
    endpoint                   = " "  # to fill
    certificate_authority_data = " "  # to fill
    oidc_issuer_url            = " "  # to fill
  }
  #
}