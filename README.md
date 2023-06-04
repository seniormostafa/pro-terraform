## Description

This is a Terraform  Project. In this project, we are demonstrating the usage of Terraform to create AWS instances within a VPC.
and look state file with daynamodb 
## Usage

- Execute the command `terraform init` to setup the project workspace.
- Execute the command `terraform apply` to provision the infrastructure. This will create a VPC with Private and Public Subnets,route table a NAT Gateway and three EC2 instances. 
-Execute the command "terraform apply -look=false " If supported by your backend, Terraform will lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state.
State locking happens automatically on all operations that could write state. You won’t see any message that it is happening. If state locking fails, Terraform will not continue.”
- Execute the command `terraform destroy` to destroy the infrastructure.

## Note

The resources created in this example may incur cost. So please take care to destroy the infrastructure if you don't need it.