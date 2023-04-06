resource "aws_s3_bucket" "cloud_app_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "cloud_app_bucket_acl" {
  bucket = aws_s3_bucket.cloud_app_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloud_app_bucket_config" {
  bucket = aws_s3_bucket.cloud_app_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "cloud_app_cors_config" {
  bucket = aws_s3_bucket.cloud_app_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "POST", "PUT"]
    allowed_origins = ["*"]
    expose_headers  = ["etag"]
  }
}

data "aws_iam_policy_document" "cloud_app_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "${aws_s3_bucket.cloud_app_bucket.arn}/*",
      aws_s3_bucket.cloud_app_bucket.arn
    ]
  }
}

resource "aws_iam_policy" "cloud_app_policy" {
  name   = "CloudAppIAMPolicy"
  policy = data.aws_iam_policy_document.cloud_app_policy_doc.json
}

resource "aws_iam_group" "cloud_app_group" {
  name = "CloudAppUsers"
}

resource "aws_iam_group_policy_attachment" "cloud_app_group_attachment" {
  group      = aws_iam_group.cloud_app_group.name
  policy_arn = aws_iam_policy.cloud_app_policy.arn
}