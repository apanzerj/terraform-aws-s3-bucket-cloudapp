# terraform-aws-s3-bucket-cloudapp

Documentation: https://support.getcloudapp.com/hc/en-us/articles/6577742705303-How-can-I-use-my-own-Amazon-AWS-S3-bucket-storage-with-CloudApp-

## Usage

```hcl
module "bucket" {
  source = "git@github.com:apanzerj/terraform-aws-s3-bucket-cloudapp.git"
  bucket_name = "some-cool-name-for-your-bucket"
}
```

Once you are done, you create an IAM user, add them to your new CloudApp user group and create an iam credential to pop into your account.