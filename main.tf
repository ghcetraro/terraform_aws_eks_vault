resource "kubernetes_namespace" "vault" {
  metadata {
    annotations = {}
    labels      = {}
    name        = "vault"
  }
}
#
resource "helm_release" "vault" {
  name              = "vault"
  namespace         = kubernetes_namespace.vault.metadata[0].name
  repository        = "https://helm.releases.hashicorp.com"
  chart             = "vault"
  version           = "0.28.1"
  atomic            = true
  reset_values      = true
  dependency_update = true
  force_update      = true
  timeout           = 900
  values = [
    templatefile("${path.module}/manifests/values.yaml", {
      acm_arn            = local.acm_certificate_arn_public
      region             = var.region
      kms_key_id         = aws_kms_key.vault.key_id
      namespace          = kubernetes_namespace.vault.metadata[0].name
      serviceAccountName = local.role_name
      iam_role_arn       = module.iam_assumable_role_admin.iam_role_arn
      table              = local.role_name
    })
  ]
  #
  depends_on = [
    kubernetes_namespace.vault,
    kubernetes_secret.vaut,
    aws_kms_key.vault,
    module.iam_assumable_role_admin,
    aws_dynamodb_table.terraform_locks,
  ]
}