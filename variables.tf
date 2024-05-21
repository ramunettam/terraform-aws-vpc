### project variables

variable "project_name" {
    type = string
  
}
variable "environment" {
    default = "dev"
  
}
variable "comman_tags" {
    type = map
    default = {}
  
}


###vpc variables

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"

}

variable "vpc_tags" {
    type = map
    default = {
        environment="dev"
    }
  
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
  
}

#### internet gateway tags

variable "gw_tags" {
    type= map
    default = {
        
    }
  
}
##public subnet tags
variable "public_subnet_cidrs" {
    type=list
    validation {
      condition = length(var.public_subnet_cidrs) == 2
      error_message = "Please enter 2 valid CIDRS"
    }
}

variable "public_subnet_tags" {
    type=map
    default ={} 
}

#### private subnet variables

variable "private_subnet_cidrs" {
    type=list
    validation {
      condition = length(var.private_subnet_cidrs) == 2
      error_message = "Please enter 2 valid CIDRS"
    }
}

variable "private_subnet_tags" {
    type=map
    default ={} 
}

variable "database_subnet_cidrs" {
    type =list
      validation {
      condition = length(var.database_subnet_cidrs) == 2
      error_message = "Please enter 2 valid CIDRS"
    }

}

variable "database_subnet_tags" {
    type = map
    default = {}
}

#### Nat gate way tags

variable "aws_nat_gateway_tags" {
    type = map
    default = {}
}
#### route table tags
variable "public_route_table_tags" {
 type=map
 default={} 
}

variable "private_route_table_tags"{
    type=map
    default={}
}

variable "database_route_table_tags"{
    type=map
    default={}
}