## VPC

Please use the `core-network` module instead of this one to handle all of the vpc setup.  This module is meant to be used from there.

## Usage

```
module "vpc" {
  source = "git@github.com:lmickh/terraform-aws-core.git//vpc"

  cidr_block    = "10.10.0.0/16"
  loc_code      = "am1"
  tags = {
    cost_center = "my-infra"
    loc_code = "am1"
    service_level = "dev"
    source =  "terraform"
  }
}
```