# README

This repository is used to install vault ha in aws, with terraform using dynamodb as storage

## Locals

	The missing information of the external components required needs to be completed
```
  dns = {
    public_zone_id  = " " # to fill
    private_zone_id = " " # to fill
  }
  #
  acm_certificate_arn_public = " "  # to fill
  #
  eks = {
    id                         = " "  # to fill
    endpoint                   = " "  # to fill
    certificate_authority_data = " "  # to fill
    oidc_issuer_url            = " "  # to fill
  }
```

## Configuration with aws sso

  - You need to create/configure your parameters in the following file  
```
    terraform.tfvars
```

  - You need to create your profile in your .aws/config and .aws/credentials

.aws/config  
```
	[profile devops]
	sso_start_url=<url>
	sso_region=<region>
	sso_account_id=<account id>
	sso_role_name=<role name>
	region=<defaul region>
	output=json
```

  - Run to obtain the credentials

  	aws sso login --profile devops

### *Terraform Individual Variables*

```
customer       = "devops"
environment    = "production"
region         = "us-east-1"
#
vault = {
  #
  dns_url = "vault-server"
  #
  secret_name = "vault-server-tls"
  #
  country                    = "USA"
  province                   = "Florida"
  locality                   = "Miami"
  common_name                = "vault-server"
  organization               = "Moon Inc."
  organizational_unit        = "Moon Root Certification Auhtority"
  validity_period_hours_ca   = 43800 //  1825 days or 5 years
  validity_period_hours_cert = 43800
}
```

## Running

To run the following scripts, you will need to have ADMIN privileges.

  Following 3 commands need to be executed for every deployment
``` 
  terraform init 
  terraform plan 
  terraform apply 
```

## Pre-requisites

- Terraform CLI is [installed](https://learn.hashicorp.com/tutorials/terraform/install-cli).  
- AWS CLI [installed](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).  

## Terraform Scripts
``` 
	certs.tf
	data-in.tf
	data.tf
	dynamodb.tf
	kms.tf
	locals.tf
	main.tf
	output.tf
	providers.tf
	role.tf
	route53.tf
	secrets.tf
	variables.tf
``` 

## Resources

Resources that are going to be deployed  
```
	AWS  
		dynamodb  
		roles  
		polices  
		eks service account  
		parameter store  
		route53 records  
		kms keys  

	EKS
		secrets
		configmap
		service account
		role
		role attachment

	External Local Resources

		private key
		cert
		ca cert authority
```

## How to initialize the vault service for the first time?

It is the only step that has to be done by hand !!!  

	From a terminal with cluster login

		kubectl exec -n vault -it vault-0 -- /bin/sh

		vault status

		vault operator init

Once you have obtained the token, save it in the secret manager that Terraform created caller:  

	vault-server-initial-token

Save in here : 

	Initial Root Token
	Recovery Key 1
	Recovery Key 2
	Recovery Key 3
	Recovery Key 4
	Recovery Key 5

## Dependencies
	
	ACM
	EKS
	DNS

## Example URL of the server

	https://vault.devops.io:8200