# Test Terraform Configuration
# This file validates terraform-lsp plugin hooks and LSP functionality

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Provider configuration
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "terraform"
      Project     = "terraform-lsp-test"
    }
  }
}

# Random suffix for unique naming
resource "random_id" "suffix" {
  byte_length = 4
}

# Example S3 bucket - tests resource completion and validation
resource "aws_s3_bucket" "test" {
  bucket = "terraform-lsp-test-${random_id.suffix.hex}"

  tags = {
    Name = "Test Bucket"
  }
}

# S3 bucket versioning - tests nested resource references
resource "aws_s3_bucket_versioning" "test" {
  bucket = aws_s3_bucket.test.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "test" {
  bucket = aws_s3_bucket.test.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 public access block - security best practice
resource "aws_s3_bucket_public_access_block" "test" {
  bucket = aws_s3_bucket.test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM role - tests IAM resource completion
resource "aws_iam_role" "test" {
  name = "terraform-lsp-test-role-${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Local values - tests locals completion
locals {
  common_tags = {
    Environment = var.environment
    Project     = "terraform-lsp-test"
  }

  bucket_name = aws_s3_bucket.test.id
}

# Data source - tests data source completion
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
