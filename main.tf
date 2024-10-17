provider "aws" {
  profile = "anil-devops"
  region  = "ap-south-1"
}

resource "aws_s3_bucket" "bucket1" {
  bucket = "anil-devops"
}

resource "aws_s3_bucket_public_access_block" "bucket1" {
  bucket                  = aws_s3_bucket.bucket1.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "bucket1" {
  bucket       = "anil-devops"
  key          = "home.html"
  source       = "home.html"
  content_type = "text/html"
  depends_on   = [aws_s3_bucket.bucket1]
}

resource "aws_s3_bucket_website_configuration" "bucket1" {
  bucket = aws_s3_bucket.bucket1.id
  index_document {
    suffix = "home.html"
  }
}

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.bucket1.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
	  "Principal": "*",
      "Action": [ "s3:GetObject" ],
      "Resource": [
        "${aws_s3_bucket.bucket1.arn}",
        "${aws_s3_bucket.bucket1.arn}/*"
      ]
    }
  ]
}
EOF
}

output "websiteendpoint" {
    value = aws_s3_bucket_website_configuration.bucket1.website_endpoint
  
}