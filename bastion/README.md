# Bastion

This module will construct IAM role, instance profile, security group, and 
instances to be used as ssh bastion boxes.

## Usage

```
module "bastion" {
  source = "git@github.com:lmickh/terraform-aws-modules.git//bastion"

  dns_zone            = "example.com"
  loc_code            = "am11"
  subnet_ids          = ["public-subnet-xxxx"]
  ssh_key_name        = "my_ec2_bastion_ssh_key_pair"
  ssh_public_key_file = "~/.ssh/id_rsa_my_key.pub"
  vm_count            = 1
  vpc_id              = "vpc-xxxx"

  tags = {
    cost_center     = "mo-money"
    data_governance = "not_so_much"
    service_level   = "prd"
    source          = "terraform"
  }
}
```