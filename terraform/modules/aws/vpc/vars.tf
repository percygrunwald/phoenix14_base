variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
}

variable "org" {
  description = "The organization"
}

variable "app_name_underscore" {
  description = "The application name delimited with underscores"
}

variable "app_name_hyphen" {
  description = "The application name delimited with hyphens"
}

variable "env" {
  description = "Environment, e.g. prod, stage, dev"
}

variable "owner" {
  description = "Creator of resources, e.g. ops or jake"
}
