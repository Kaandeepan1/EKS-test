#S3 bucket that stores Terraform state for the main EKS project
resource "aws_s3_bucket" "tfstate" {
  bucket = "deepan-tfstate-${data.aws_caller_identity.current.account_id}"

  # Safety: Terraform refuses to delete this bucket
#  lifecycle {
#    prevent_destroy = true
#  }
}

#Keep every old version of the state file (undo for mistakes)
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Encrypt everything stored in the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Block all public access - state must never be public
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}