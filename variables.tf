### project variables

variable "project_name" {
    type = string
  
}

variable "environment" {
    type = string
  
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

variable "public_subnet_cidrs" {
    type=list
    validation {
      condition = length(var.public_subnet_cidrs) == 2
      error_message = "Please enter 2 valid cidirs"
    }
}