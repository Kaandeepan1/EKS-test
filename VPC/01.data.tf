#Get the list of available AZs in the current region
data "aws_availability_zones" "available" {
  state = "available"
}

#Find the latest Amazon Linux 2023 AMI (ARM / Graviton for t4g)
data "aws_ami" "EC2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}