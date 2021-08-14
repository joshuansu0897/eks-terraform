# DEFAUL VALUES
# Choose in case you have multiple profiles on your workstation
aws_profile ?= default
# Choose the AWS region to use
aws_region ?=  us-west-2
# Switch to different TF image version
tf_versions ?= 1.0.4

PWD ?= $(shell pwd)
HOME ?= ~/

# Terraform container
TERRAFORM := docker run -i --rm -t \
		-v ${PWD}:/terraform/ \
		-v ${HOME}\.aws:/root/.aws \
		-w /terraform/src/ \
		hashicorp/terraform:${tf_versions}

# Terraform with sh entrypoint
TERRAFORMBASH := docker run -i --rm -t \
		-v ${PWD}:/terraform/ \
		-v ${HOME}\.aws:/root/.aws \
		--entrypoint=/bin/sh \
		--env AWS_PROFILE="${aws_profile}" \
		--env AWS_REGION="${aws_region}" \
		-w /terraform/terraform \
		hashicorp/terraform:${tf_versions}

# Format files
.PHONY: fmt
fmt:
	$(TERRAFORM) fmt --recursive

# Terraform sh
.PHONY: bash
bash:
	$(TERRAFORMBASH)

# Terraform Init
.PHONY: init
init:
	$(TERRAFORM) init

# Terraform plan
.PHONY: plan
plan:
	$(TERRAFORM) plan -var 'aws_profile=$(aws_profile)' -var 'aws_region=${aws_region}'

# Terraform apply
.PHONY: apply
apply:
	$(TERRAFORM) apply  -var 'aws_profile=$(aws_profile)' -var 'aws_region=${aws_region}'

# Terraform destroy
.PHONY: destroy
destroy:
	$(TERRAFORM) destroy -var 'aws_profile=$(aws_profile)' -var 'aws_region=${aws_region}'
