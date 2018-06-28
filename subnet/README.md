# terraform-aws-subnet

This code makes the assumption that you likely mean to build multiple subnets
together.  This is so that they can be spread across multiple AZ to avoid
network partitions.

It will create the first subnet network address based on the following values:

`cidr_block + subnet_offset + subnet_netnum`

Ex: `10.11.0.0/17 + 7 offset` = `10.11.0.0/24 + 15 netnum` = `10.11.15.0/24`

Just pretend like that is real math.

Subsequent subnets will be incremented from that:

Ex. With 2 AZs, it would create `10.11.15.0/24` and `10.11.16.0/24`.

## Usage

```
module "example" {
  source = "git@github.com:lmickh/terraform-aws-core.git//subnet"

  num_availability_zones = 3
  cidr_block             = "10.10.0.0/16"
  subnet_offset          = 8
  subnet_netnum          = 16
  loc_code               = "am1"
  name                   = "example"
  vpc_id                 = "vpc-1234abcd"
}
```