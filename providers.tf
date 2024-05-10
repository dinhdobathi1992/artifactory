
# Required for Terraform 1.0 and up (https://www.terraform.io/upgrade-guides)
terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "5.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.55.0"
    
    }
  }
}

provider "time" {
  
}

# Configure the Artifactory provider
provider "artifactory" {
  url     = "https://jasonadwards9292.jfrog.io/artifactory"
  access_token = var.jfrog_access_token

}


provider "aws" {
  region = "ap-southeast-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}