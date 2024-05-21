
### vpc
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

### internet gate way
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

#### database subnet
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

### elastic ip
resource "aws_eip" "nat" {
  domain   = "vpc"
}

### Nat gate way
resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.comman_tags,
    var.aws_nat_gateway_tags,
    { Name= "${ local.resource_name}" }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

### public route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  
  tags = merge(
    var.comman_tags,
    var.public_route_table_tags,
    {
    Name = "${local.resource_name}-public"
  }
  )
}

### private route table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  
  tags = merge(
    var.comman_tags,
    var.private_route_table_tags,
    {
    Name = "${local.resource_name}-private"
  }
  )
}

### database route table

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  
  tags = merge(
    var.comman_tags,
    var.database_route_table_tags,
    {
    Name = "${local.resource_name}-database"
  }
  )
}

### public route

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
  
}

### private route
resource "aws_route" "private_route_nat" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
  
}

resource "aws_route" "database_route_nat" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
  
}

#### route table association with subnets

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}



