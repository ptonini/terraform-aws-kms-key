resource "aws_kms_key" "this" {
  description              = coalesce(var.description, var.name)
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  policy = var.policy_statement == null ? null : jsonencode({
    Version   = var.policy_api_version
    Statement = var.policy_statement
  })
  tags = merge({ Name = var.name }, var.tags)
}


module "access_policy" {
  #checkov:skip=CKV_TF_1: Private module
  source  = "ptonini/iam-policy/aws"
  version = "~> 2.0.0"
  count   = var.access_policy ? 1 : 0
  name    = "${var.name}-kms-key"
  statement = [{
    Effect = "Allow"
    Action = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ],
    Resource = [aws_kms_key.this.arn]
  }]
}