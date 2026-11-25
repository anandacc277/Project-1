# Terraform AWS Web Server

This Terraform project provisions a public-facing Apache web server on AWS.

It creates:

- A VPC with a public subnet
- An internet gateway and public route table
- An EC2 security group
- An Amazon Linux 2 EC2 instance
- Apache HTTPD and a health check page

The web server is accessible over HTTP. The security group also reserves HTTPS port 443, although Apache is not configured with a TLS certificate.
## Architecture

```text
Internet
   |
Internet Gateway
   |
Public Route Table
   |
Public Subnet
   |
EC2 Instance (Apache)
```

## Prerequisites

- Terraform 1.0 or newer
- AWS account
- AWS CLI configured with credentials that can create VPC, EC2, and security group resources

Verify your AWS identity:

```bash
aws sts get-caller-identity
```

## Quick Start

Clone the repository and enter the project directory:

```bash
git clone <repository-url>
cd Project-1
```

Initialize Terraform:

```bash
terraform init
```

Review the resources that will be created:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Enter `yes` when prompted. After deployment, open the URL shown by the `web_server_url` output:

```bash
terraform output web_server_url
```

## Configuration

The deployment can be customized with variables in `variables.tf` or a `.tfvars` file.

| Variable | Description | Default |
|---|---|---|
| `aws_region` | AWS region | `us-east-1` |
| `environment` | Environment name used for default resource tags | `dev` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `subnet_cidr` | Public subnet CIDR block | `10.0.1.0/24` |
| `instance_type` | EC2 instance type | `t3.micro` |
| `enable_public_ip` | Assign a public IP to the EC2 instance | `true` |

Example using a custom variables file:

```hcl
# terraform.tfvars
aws_region      = "us-west-2"
environment     = "production"
instance_type   = "t3.small"
vpc_cidr        = "10.20.0.0/16"
subnet_cidr     = "10.20.1.0/24"
enable_public_ip = true
```

Apply the custom configuration:

```bash
terraform apply -var-file="terraform.tfvars"
```

## Outputs

| Output | Description |
|---|---|
| `vpc_id` | VPC ID |
| `subnet_id` | Public subnet ID |
| `security_group_id` | Web security group ID |
| `instance_id` | EC2 instance ID |
| `instance_public_ip` | EC2 public IP address |
| `instance_private_ip` | EC2 private IP address |
| `web_server_url` | URL for the Apache web server |
| `instance_arn` | EC2 instance ARN |
| `availability_zone` | EC2 availability zone |

View all outputs:

```bash
terraform output
```

## Instance Setup

The `userdata.sh` script runs once when the instance is launched. It:

- Updates the Amazon Linux 2 packages
- Installs Apache HTTPD
- Starts and enables the HTTPD service
- Creates the welcome page
- Creates `/health.txt`

Common verification commands:

```bash
# Welcome page
curl http://<instance-public-ip>/

# Health check
curl http://<instance-public-ip>/health.txt
```

## Security

The security group allows:

- TCP port 80 from `0.0.0.0/0`
- TCP port 443 from `0.0.0.0/0`
- TCP port 22 from `0.0.0.0/0`
- All outbound traffic

For a production deployment:

- Restrict SSH access to a trusted IP address or VPN CIDR
- Configure an EC2 key pair before enabling SSH access
- Use HTTPS with a TLS certificate and load balancer or proxy
- Avoid committing Terraform state or credentials to source control
- Use a remote Terraform backend for shared environments

## Project Structure

```text
.
├── ec2.tf           # EC2 instance and Amazon Linux AMI lookup
├── output.tf        # Terraform outputs
├── provider.tf      # AWS provider and Terraform requirements
├── security.tf      # Security group rules
├── userdata.sh      # EC2 bootstrap script
├── variables.tf     # Input variables
├── vpc.tf           # VPC, subnet, gateway, and routing
└── terraform.tfstate # Local Terraform state, if present
```

## Cleanup

Remove all resources created by this project:

```bash
terraform destroy
```

Enter `yes` when prompted.
