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

###public sunnet

resource "aws_subnet" "public" {

  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone = local.az_names[count.index]
  cidr_block = var.public_subnet_cidrs[count.index]

  tags = merge(
    var.comman_tags,
    var.public_subnet_tags,
    { Name="${local.resource_name}-public-${local.az_names[count.index]}"}
  )
}
    
  
####private subnet

resource "aws_subnet" "private" {

  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(
    var.comman_tags,
    var.private_subnet_tags,
    {Name="${local.resource_name}-private-${local.az_names[count.index]}"}
  )
}

resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(
    var.comman_tags,
    var.database_subnet_tags,
    {Name="${local.resource_name}-database-${local.az_names[count.index]}"}
  )

}
