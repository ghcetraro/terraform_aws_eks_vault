output "secret_ids" {
  description = "Parameter Store ids map"
  value       = { for k, v in aws_ssm_parameter.secret : k => v["id"] }
}

output "secret_arns" {
  description = "Secrets arns map"
  value       = { for k, v in aws_ssm_parameter.secret : k => v["arn"] }
}