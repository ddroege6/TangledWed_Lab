terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.50" } }
  backend "local" {}
}

provider "aws" { region = var.region }

locals {
  name        = "${var.project_name}-${var.environment}"
  tags = { Project = var.project_name, Environment = var.environment, Owner = var.owner }
}

data "aws_availability_zones" "azs" {}
