#
module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v5.5.6"
  create_role                   = true
  role_name                     = local.role_name
  provider_url                  = replace(data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.vault.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${kubernetes_namespace.vault.metadata[0].name}:${local.role_name}"]
}
#
data "aws_iam_policy_document" "vault" {
  statement {
    sid    = "VaultKms"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:DescribeKey"
    ]
    resources = ["arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/${local.role_name}"]
  }
  #
  statement {
    sid    = "VaultDynamodbAccess"
    effect = "Allow"
    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]
    resources = ["arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${local.role_name}"]
  }
}
#
resource "aws_iam_policy" "vault" {
  name_prefix = "${local.role_name}-role"
  description = "EKS vault policy for cluster ${data.terraform_remote_state.eks.outputs.cluster_id}"
  policy      = data.aws_iam_policy_document.vault.json
}
#