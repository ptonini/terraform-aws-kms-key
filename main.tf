resource "aws_kms_key" "this" {
  description = var.name
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation = var.enable_key_rotation
}

module "user" {
  source = "ptonini/iam-user/aws"
  version = "~> 1.0.0"
  count = var.access_key ? 1 : 0
  username = var.username == null ? var.name : var.username
  access_key = true
  policy_statements = [{
    Sid = "VaultKMSUnseal"
    Effect = "Allow",
    Action = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ],
    Resource = ["*"]
  }]
}
