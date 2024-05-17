resource "aws_vpc" "main" {
  
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy = "default"

  tags = merge(
    var.comman_tags,
    var.vpc_tags,

    { Name =local.resource_name}

  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
     var.comman_tags ,
     var.gw_tags ,
     { Name= local.resource_name }
  )

  
}

resource "aws_subnet" "public" {
  count = length(var.public_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidrs[count.index]

  tags = merge(
    
  )
    
  
}
