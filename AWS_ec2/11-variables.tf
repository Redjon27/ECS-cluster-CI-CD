#######################################################################################
# EC2 instance Variable , S/G
#######################################################################################

variable "vpc_id" {
  type        = string
  description = "ID of an existing VPC in which to create the cluster."
  default     = "vpc-0c929d201065c9a4a"
}

variable "subnet_id" {
  type        = string
  description = "ID of an existing subnet in which to create the cluster. The subnet must be in the VPC specified in the \"vpc_id\" variable, otherwise an error occurs."
  default     = "subnet-09f6ccee580256269"
}

variable "subnet_id1" {
  type        = string
  description = "ID of an existing subnet in which to create the cluster. The subnet must be in the VPC specified in the \"vpc_id\" variable, otherwise an error occurs."
  default     = "subnet-0e8251e240b76f3d3"
}

variable "key_name" {
  type        = string
  description = "Name of an existing EC2 key pair for SSH access to the EC2 instance"
  default     = "redjon"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance"
  default     = "t2.micro"
}

variable "ami" {
  type        = string
  description = "The image of EC2 - Ubuntu"
  default     = "ami-06ce824c157700cd2"
}

variable "region" {
  type        = string
  description = "aws region"
  default     = "eu-central-1"
}

#######################################################################################
# Route 53 variables
#######################################################################################

variable "domain_name" {
  type    = string
  default = "devops.internal.rbigroup.cloud"
}

variable "record_name" {
  default     = "CNAME"
  type        = string
  description = "sub domain name"
}

variable "alternative_name" {
  type    = string
  default = "*.devops.internal.rbigroup.cloud"
}