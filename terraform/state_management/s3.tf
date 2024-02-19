locals {
  # Set your desired bucket prefix here
  bucket_prefix = "poridhi-"

  # Generate a random string with specified length
  random_string = random_pet.bucket_name.id
}

resource "random_pet" "bucket_name" {
  length = 6 # Adjust length as needed (e.g., 12 for higher uniqueness)
}

# Configure an S3 bucket resource to hold application state files
resource "aws_s3_bucket" "terraform_state" {
  bucket = format("%s%s", local.bucket_prefix, local.random_string)
}


# Add bucket versioning for state rollback
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Add bucket encryption to hide sensitive state data
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}