
# Get the latest ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create an elastic IP
resource "aws_eip" "elastic_ip" {
}

resource "aws_eip_association" "epi_assoc" {
  instance_id   = aws_instance.app_server.id
  allocation_id = aws_eip.elastic_ip.id
}

# Set region
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Create AMI
resource "aws_instance" "app_server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = ["sg_nextcloud"]

  # Key must already exist in AWS
  key_name = "nextcloud-1"
}

