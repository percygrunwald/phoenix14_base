variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = ""
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  default     = []
}

variable "database_subnets" {
  type        = "list"
  description = "A list of database subnets"
  default     = []
}

variable "create_database_subnet_group" {
  description = "Controls if database subnet group should be created"
  default     = false
}

variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}

 variable "enable_nat_gateway" {
   description = "Should be true if you want to provision NAT Gateways for each of your private networks"
   default     = false
 }
