#######################################################################################
# Create vpc
# Terraform aws create vpc
#######################################################################################

/* resource "aws_vpc" "vpc" {
  cidr_block              = 
  instance_tenancy        = 
  enable_dns_hostnames    = 

  tags      = {
    Name    = 
  }
} */

#######################################################################################
# Create internet gateway and attach it to vpc
# Terraform aws create internet gateway
#######################################################################################

/* resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = 

  tags      = {
    Name    = 
  }
} */

#######################################################################################
# Create public subnet az1
# Terraform aws create subnet
#######################################################################################

/* resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = 
  cidr_block              = 
  availability_zone       = 
  map_public_ip_on_launch = 

  tags      = {
    Name    = 
  }
} */

#######################################################################################
# Create public subnet az2
# Terraform aws create subnet
#######################################################################################

/* resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = 
  cidr_block              = 
  availability_zone       = 
  map_public_ip_on_launch = 

  tags      = {
    Name    = 
  }
} */

#######################################################################################
# Create route table and add public route
# Terraform aws create route table
#######################################################################################

/* resource "aws_route_table" "public_route_table" {
  vpc_id       = 

  route {
    cidr_block = 
    gateway_id = 
  }

  tags       = {
    Name     = 
  }
} */

#######################################################################################
# Associate public subnet az1 to "public route table"
# Terraform aws associate subnet with route table
#######################################################################################

/* resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id           = 
  route_table_id      = 
} */

#######################################################################################
# Associate public subnet az2 to "public route table"
# Terraform aws associate subnet with route table
#######################################################################################

/* resource "aws_route_table_association" "public_subnet_2_route_table_association" {
  subnet_id           = 
  route_table_id      = 
} */

#######################################################################################
# Create private app subnet az1
# Terraform aws create subnet
#######################################################################################

/* resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                   = 
  cidr_block               = 
  availability_zone        = 
  map_public_ip_on_launch  = 

  tags      = {
    Name    = 
  }
} */

#######################################################################################
# Create private app subnet az2
# Terraform aws create subnet
#######################################################################################

/* resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                   = 
  cidr_block               = 
  availability_zone        = 
  map_public_ip_on_launch  = 

  tags      = {
    Name    = 
  }
} */

#######################################################################################
# Create private data subnet az1
# Terraform aws create subnet
#######################################################################################

/* resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                   = 
  cidr_block               = 
  availability_zone        = 
  map_public_ip_on_launch  = 

  tags      = {
    Name    = 
  }
} */

#######################################################################################
# Create private data subnet az2
# Terraform aws create subnet
#######################################################################################

/* resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                   = 
  cidr_block               = 
  availability_zone        = 
  map_public_ip_on_launch  = 

  tags      = {
    Name    = 
  }
} */