#######################################################################################
# S3 Bucket -- Backend
#######################################################################################

/* terraform {
  backend "s3" {
    bucket         = "redjon-bucket"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    acl            = "private"
    dynamodb_table = "table"
    encrypt        = true
  }
} */

#######################################################################################
# Resource to create S3 bucket
#######################################################################################

resource "aws_s3_bucket" "redjon-bucket" {
  bucket = "redjon-bucket"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "S3Bucket"
    Environment = "Test"
  }
}

#######################################################################################
# Resource to enable versioning 
#######################################################################################

resource "aws_s3_bucket_versioning" "versioning_redjon" {
  bucket = aws_s3_bucket.redjon-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#######################################################################################
# Resource to enable encryption
#######################################################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "redjon-encryption" {
  bucket = aws_s3_bucket.redjon-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#######################################################################################
# Adds an Access Control Lists (ACL) to bucket
#######################################################################################

resource "aws_s3_bucket_acl" "redjon_bucket_acl" {
  bucket = aws_s3_bucket.redjon-bucket.bucket
  acl    = "private"
}

#######################################################################################
# Block Public Access
#######################################################################################

resource "aws_s3_bucket_public_access_block" "redjon_public_block" {
  bucket = aws_s3_bucket.redjon-bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#######################################################################################
# Resource to create Dynamodb Table
#######################################################################################

resource "aws_dynamodb_table" "table" {
  name         = "table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}