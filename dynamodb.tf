#
resource "aws_dynamodb_table" "terraform_locks" {
  name           = local.role_name
  hash_key       = "Path"
  range_key      = "Key"
  billing_mode   = "PROVISIONED"
  read_capacity  = "30" # approximate need according to last test
  write_capacity = "30" # approximate need according to last test

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
  tags = local.tags
}