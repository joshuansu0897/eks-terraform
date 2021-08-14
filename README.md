# SolutionsArchitectAssociateAWS-Terraform
All tools you need to get you SolutionsArchitectAssociateAWS on Terraform

## AWS deployment

All the infrastructure deploys by default on `us-west-2`. If you want to deploy in a different region pass the `aws_region` parameter to `make`.

## Tools creation steps

Create a named profile for the AWS Command Line Interface (CLI). Once you have your AWS credentials on `~/.aws/credentials` like this:

```bash
[myprofile]
aws_access_key_id=LAGALDASDASDASDASDSADSA
aws_secret_access_key=dsadsadsasafsdasdasdsa
```

Variables/Parameters:

- aws_profile = refers to your AWS profile credentials as you have them set on your workstation (by default use `default`)
- aws_region = name of the AWS region where the infrastructure will be deployed (by default use `us-west-2`)
- tools = it's the tool/app you want to deploy (by default use `s3`)
- tf_versions = Switch to different TF image version (by default use `1.0.4`)

```bash
$ make init aws_profile=myprofile tools=tool_name
$ make plan aws_profile=myprofile tools=tool_name
$ make apply aws_profile=myprofile tools=tool_name
$ make destroy aws_profile=myprofile tools=tool_name
```
