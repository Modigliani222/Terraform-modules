variable "vpc_cidr" {
default = "10.0.0.0/16"
}

variable "public_subnets_cidrs" {
default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "public_private_cidrs" {
default = "10.0.3.0/24"
}

variable "env" {
default = "dev"
}
