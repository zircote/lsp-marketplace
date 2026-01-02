# Test Outputs
# Validates output completion and reference resolution

output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.test.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.test.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.test.bucket_domain_name
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.test.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.test.name
}

output "account_id" {
  description = "The AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "The AWS region"
  value       = data.aws_region.current.name
}

output "common_tags" {
  description = "Common tags applied to resources"
  value       = local.common_tags
}
