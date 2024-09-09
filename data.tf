#
data "aws_caller_identity" "current" {}
#
data "kubernetes_service" "vault" {
  metadata {
    name      = "vault-ui"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }
  depends_on = [
    helm_release.vault,
  ]
}