
                resource "aws_s3_bucket" "b" {
                  bucket = "my-s3-bucket-${random_string.bucket_suffix.result}"
                  acl    = "private"

                  tags = {
                    Name        = "MyS3Bucket"
                    Environment = "Dev"
                  }
                }

                resource "random_string" "bucket_suffix" {
                  length  = 6
                  special = false
                }

