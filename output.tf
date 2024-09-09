#
output "loadbalancer_url" {
  value = data.kubernetes_service.vault.status.0.load_balancer.0.ingress.0.hostname
}
#
output "aws_route53_record" {
  value = aws_route53_record.vault_public.fqdn
}
#
output "vault_url" {
  value = "https://${aws_route53_record.vault_public.fqdn}:8200"
}
#
output "aws_dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_locks.arn
}
#
output "vault_secret_manager" {
  value = aws_secretsmanager_secret.vault.id
}