#######################################################################################
# AWS -- Hashicorp -- Provider
#######################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.38.0"
    }
  }
}

provider "aws" {
  region = var.region
}

#######################################################################################
# Create EC2 Instance -- Install GitHub-hosted runners
#######################################################################################

resource "aws_instance" "app_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = [aws_security_group.AWS_SG2.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = false
  monitoring                  = true

  tags = {
    Name = "Example-EC2-Instance"
  }
  user_data = <<-EOF
 #!/bin/sh
 sudo apt-get update
 sudo apt-get upgrade -y
 sudo apt-get install git -y
 sudo apt-get update
 sudo -u ubuntu mkdir /home/ubuntu/actions-runner && cd "actions-runner"
 sudo -u ubuntu curl -o /home/ubuntu/actions-runner/actions-runner-linux-x64-2.296.2.tar.gz -L -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IjZlR19ZRlJBazREVlc3cmNNOXB1WlVHV2szQSJ9.eyJuYW1laWQiOiJkZGRkZGRkZC1kZGRkLWRkZGQtZGRkZC1kZGRkZGRkZGRkZGQiLCJzY3AiOiJBY3Rpb25zUnVudGltZS5QYWNrYWdlRG93bmxvYWQiLCJJZGVudGl0eVR5cGVDbGFpbSI6IlN5c3RlbTpTZXJ2aWNlSWRlbnRpdHkiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiOiJERERERERERC1ERERELUREREQtRERERC1EREREREREREREREQiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ByaW1hcnlzaWQiOiJkZGRkZGRkZC1kZGRkLWRkZGQtZGRkZC1kZGRkZGRkZGRkZGQiLCJhdWkiOiI1NDZkMzQ4OS0zZTIzLTQ1MjctOWY0Yi1lODUwZDliNDM4YzgiLCJzaWQiOiI0NmFkN2UzMS1iMmZmLTQxZjktODM0Zi1lM2NhZTdiZDU4MmMiLCJpc3MiOiJjb2RlLnJiaS50ZWNoIiwiYXVkIjoiY29kZS5yYmkudGVjaC9fc2VydmljZXMvdnN0b2tlbiIsIm5iZiI6MTY3MTExMDExMSwiZXhwIjoxNjcxMTE0MzEwfQ.GLRbKoZ85vNquz9QM8Rx3aE_qK6e9sSGtPl4AdExsP_h_kOTybkO6N-V6bRW3Tfmxr0fAhcrZwCHqAhOePtcFAJ1IfF6D6bH82c9USD5_183Q14spRgFNHpUswB19giYGZoupdrPxF4DwKegB4Iled5NBejqwNpo1VuULsgrctUafbDM_BrO2YvGaLc5VmWUCj4tnD0_iDv4PCrO6q_6JiN3E5GpFOj6oQSPPg0WafDh8N06RUNrugPVi2ZC2_B5pSUUZk7ZxNsunZZpn2drowp2WNdyQQpAe1HEzQ9QSvo6RzzNPDTuvzo3CfkkMLE3wR9orWUzJeezaDJQOO3OAg9iVI6HWFqus0GbSfTQdFTiM7b67vBso7iQzWiJBc_M69MFsUDXWcXLiV1_TYQwZLebIw4BPSIKdVQczGe69YYCXfOVd07tRoLC0uo5ZqRqBf1XnhQxoJC_E-VbCP9ea-Dc3b1ZyRfjAB69ahPPFbsTS0GnMX83il1uHoRUPr26zR6pLJTwkTDjxk3bTUNVk0YBb13FELlyQKhQRcRBFrXbFNz4z9mrwJawE4SB-fBJpb2Z3n71VsZq92Uy7n4-vwogPo6zAIRxOCWNZqNvOaIYE89BsBNj88aUBcdx72LGTgNEiD-Tj35XKcpa5b3FhCEmfsrLz9CEku3LgHsDpKU' https://code.rbi.tech/_services/pipelines/_apis/distributedtask/packagedownload/agent/linux-x64/2.296.2
 sudo -u ubuntu echo "34a8f34956cdacd2156d4c658cce8dd54c5aef316a16bbbc95eb3ca4fd76429a  actions-runner-linux-x64-2.296.2.tar.gz" | shasum -a 256 -c
 sudo -u ubuntu tar xzf /home/ubuntu/actions-runner/./actions-runner-linux-x64-2.296.2.tar.gz -C /home/ubuntu/actions-runner/ --strip-components=1
 sudo -u ubuntu rm -r /home/ubuntu/actions-runner/./actions-runner-linux-x64-2.296.2.tar.gz
 sudo -u ubuntu /home/ubuntu/actions-runner/./config.sh --url https://code.rbi.tech/raiffeisen/Test-WebApplication --token AAABZ42JEHAO5U5HQBCE6XTDVMDLK --name "Github EC2 Runner" --unattended
 sudo -u ubuntu /home/ubuntu/actions-runner/./run.sh
 EOF
}