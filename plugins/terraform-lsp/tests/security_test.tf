# Security Test File
# This file contains INTENTIONAL security issues for testing trivy and checkov hooks
# DO NOT use this configuration in production!

# TODO: This is a test TODO comment - should be detected by terraform-todo-fixme hook
# FIXME: This is a test FIXME comment - should be detected

# Test: Unencrypted S3 bucket (trivy/checkov should flag this)
resource "aws_s3_bucket" "insecure_test" {
  bucket = "insecure-test-bucket-${random_id.suffix.hex}"

  # Missing: server-side encryption
  # Missing: public access block
  # Missing: versioning

  tags = {
    Name    = "Insecure Test Bucket"
    Purpose = "Hook Testing"
  }
}

# Test: Security group with overly permissive ingress (should be flagged)
resource "aws_security_group" "overly_permissive" {
  name        = "overly-permissive-sg"
  description = "Test security group with issues"

  # This should trigger security warnings - allows all traffic from anywhere
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all TCP - INSECURE FOR TESTING"
  }

  # SSH from anywhere - should be flagged
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH from anywhere - INSECURE FOR TESTING"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Test SG"
    Purpose = "Hook Testing"
  }
}

# Test: RDS without encryption (should be flagged)
resource "aws_db_instance" "unencrypted" {
  identifier        = "test-unencrypted-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "testdb"
  username = "admin"
  password = "insecure_password_for_testing" # Should trigger terraform-sensitive-check

  # Missing: storage_encrypted = true
  # Missing: deletion_protection = true
  publicly_accessible = true # Should be flagged

  skip_final_snapshot = true

  tags = {
    Name    = "Test DB"
    Purpose = "Hook Testing"
  }
}

# Test variable with sensitive content pattern (should trigger terraform-sensitive-check)
variable "test_api_key" {
  description = "Test API key variable"
  type        = string
  default     = "test-api-key-12345"
  sensitive   = true
}
