resource "aws_s3_bucket" "public_bucket" {
  bucket = "${var.project_name}-${var.env}-public-bucket"

  tags = {
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.public_bucket.id

  depends_on = [
    aws_s3_bucket_public_access_block.public_access
  ]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowFirmwareDownload",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.project_name}-${var.env}-public-bucket/pumpNode-firmware/*"
      }
    ]
    }
  )
}
