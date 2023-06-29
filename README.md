# Terraform-ECS-Module

## Overview

The Terraform ECS Module is designed to provision a set of resources required to deploy and manage an ECS (Elastic Container Service) cluster on AWS. It includes various components such as ALB (Application Load Balancer) with ACM (AWS Certificate Manager), Route 53 for DNS management, ECR (Elastic Container Registry) for Docker image storage, ECS task definition with IAM roles, SSM (Systems Manager Parameter Store) for storing sensitive configuration, EIP (Elastic IP), NAT gateway, Internet Gateway, Route table, Security Group, and VPC subnet.

## Included Modules

- `alb-acm-route53`: This module handles the creation and configuration of the Application Load Balancer, AWS Certificate Manager and Route53. These components ensure secure and efficient routing of traffic to your services.

- `ecr`: The Elastic Container Registry module is responsible for storing and managing Docker container images. This ensures that your ECS services can reliably pull the Docker images they need to run.

- `ecs-iam-ssm`: This module creates IAM roles for ECS tasks and integrates with AWS SSM (Systems Manager). This allows your services to have the correct permissions and enables features like secure parameter storage and retrieval.

- `eip-nat-igw-rt`: This module creates Elastic IP, NAT gateway, and Internet Gateway and associated route tables. It's a vital part for the internet accessibility and routing of your services.

- `security-group`: A security group acts as a virtual firewall for your ECS services, controlling inbound and outbound traffic. This module creates and configures the necessary security groups for your cluster.

- `ssm`: This standalone Systems Manager module provides advanced features, including automated configuration management, inventory, and patch management.

- `vpc-subnet`: This module sets up a Virtual Private Cloud (VPC) and associated subnets. These are foundational components of your AWS environment that provide a private, isolated section of the AWS Cloud where you can launch resources.


## Prerequisites

Before using this module, ensure you have the following:

- AWS account credentials and access keys.
- Basic knowledge of Terraform.
- Familiarity with AWS ECS and related services.

## Usage

1. Clone this repository to your local machine.

2. Create a new Terraform configuration file (e.g., `main.tf`) and define the module.

   ```hcl
   module "ecs_cluster" {
     source = "./path/to/module"
   
     // Customize the input variables as needed
     // Example: vpc_id = "vpc-12345678"
   }
## Getting Started

Clone this repository to your local machine to get started. You'll need to have Terraform installed and correctly configured with your AWS credentials.

```shell
git clone https://github.com/your-repo/terraform-aws-ecs-module.git
cd terraform-aws-ecs-module
terraform init
terraform apply