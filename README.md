# eks-terraform
Create a EKS

note: i will add `yml` files for K8S

## AWS deployment

All the infrastructure deploys by default on `us-west-2`. If you want to deploy in a different region pass the `aws_region` parameter to `make`.

## Tools creation steps

Create a named profile for the AWS Command Line Interface (CLI). Once you have your AWS credentials on `~/.aws/credentials` like this:

```bash
[myprofile]
aws_access_key_id=LAGALDASDASDASDASDSADSA
aws_secret_access_key=dsadsadsasafsdasdasdsa
```


```pw
$ make PWD=${PWD} HOME=${HOME} destroy
```
