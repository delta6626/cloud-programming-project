# Cloud Programming (DLBSEPCP01_E) - Task 1: Hosting a Simple Webpage on AWS

A static "Hello, world!" webpage hosted on AWS and provisioned entirely with Terraform.
The website files live in a private Amazon S3 bucket and are served worldwide over HTTPS through Amazon CloudFront.

**Live site: https://d2fxf96e1a5r7g.cloudfront.net/**

## Overview

```text
Users (HTTPS) -> Amazon CloudFront -> (OAC, SigV4) -> Private Amazon S3 bucket
```

- **Amazon S3:** stores `index.html` in a private bucket (Block Public Access, Bucket Owner Enforced).
- **Amazon CloudFront:** serves the page over HTTPS on the default `*.cloudfront.net` domain.
- **OAC and bucket policy:** only this CloudFront distribution can read the bucket.
- **Terraform:** creates and configures everything above.

## Prerequisites

- An AWS account and an IAM user with an access key and permissions to manage S3 and CloudFront
- [AWS CLI](https://aws.amazon.com/cli/)
- [Terraform](https://developer.hashicorp.com/terraform) (newer than 1.6.0)

## Clone the repository

```bash
git clone https://github.com/delta6626/cloud-programming-project.git
```

Then open the `terraform` directory, which holds all the Terraform files. Every `terraform` command below is run from it.

```bash
cd cloud-programming-project/terraform
```

## Configuration

Set these in `terraform.tfvars`:

| Variable | Description |
| --- | --- |
| `bucket_name` | S3 bucket name. Must be globally unique. See the [S3 bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html). |
| `oac_name` | Name of the CloudFront Origin Access Control. Must be unique within your AWS account. |

**Important:** the `bucket_name` in `terraform.tfvars` is my bucket. If it still exists, `terraform apply` fails, so set your own name first.

The region is `eu-north-1` (Stockholm), set in `providers.tf`.

## Deployment

Configure your AWS credentials, if you haven't already:

```bash
aws configure
```

It asks for values such as your AWS Access Key ID and AWS Secret Access Key.

Once that is done and `terraform.tfvars` contains your own unique names, run the following commands one by one:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform will print these outputs:

| Output | Description |
| --- | --- |
| `private_s3_bucket_name` | Name of the S3 bucket |
| `cloudfront_distribution_id` | ID of the CloudFront distribution |
| `cloudfront_url` | Public HTTPS URL of the website |

Open `cloudfront_url` in a browser to see the page.

## Cleanup

To remove all resources and avoid charges:

```bash
terraform destroy
```
