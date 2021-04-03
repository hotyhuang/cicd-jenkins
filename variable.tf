# These are empty defined vars, just to pass from jenkins deploy
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}
variable "env" {}
variable "project_name" {}
variable "new_instance_type" {}

# The below vars are required
variable "security_group_ids" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "subnet_id2" {
  default = ""
}

variable "aws_account_num" {
  default = ""
}

variable "key_pair_name" {
  default = ""
}

variable "r53_zone_id" {
  default = ""
}

variable "r53_domain_name" {
  default = ""
}