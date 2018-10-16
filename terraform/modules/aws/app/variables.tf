# Add module-specific variables here
variable "instance_size" {
  description = "Size of the EC2 instance"
  default = "t2.micro"
}

variable "count" {
  description = "Number of EC2 instances to launch"
  default = 1
}

variable "assign_public_ip" {
  description = "Whether or not to assign a public IP to the instance(s)"
  default = true
}

variable "disk_size_gb" {
  description = "The size of the root volume in GB"
  default = 10
}

variable "static_ip" {
  description = "Whether or not to assign a static IP"
  default = false
}


