######### private records ########################################
resource "aws_route53_record" "vault_private" {
  zone_id = local.dns.private_zone_id
  name    = var.vault.dns_url
  type    = "CNAME"
  ttl     = 60
  records = [data.kubernetes_service.vault.status.0.load_balancer.0.ingress.0.hostname]
  #
  depends_on = [
    helm_release.vault,
  ]
}