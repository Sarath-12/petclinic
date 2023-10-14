packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "Amazon_ami_image" {
  region                      = "us-east-2"
  ami_name                    = "ami-build-with-packer-{{timestamp}}"
  instance_type               = "t2.micro"
  source_ami                  = "ami-056c1e176f5af0928"
  ssh_username                = "ec2-user"
  associate_public_ip_address = true
  subnet_id                   = "subnet-05673dafbf77b3d26"
  security_group_id           = "sg-067e9d860469a5eb2" 
  ami_regions = [
    "us-east-2"
  ]
}

build {
name = "hq-packer"
sources = [
     "amazon-ebs.Amazon_ami_image"
   ]
   provisioner "ansible" {
   playbook_file = "AmznLinux2_playbook.yml"
   }
 }

build {
  name = "hq-packer"
  sources = [
    "source.amazon-ebs.Amazon_ami_image"
  ]

  provisioner "file" {
  source = "provisioner.sh"
  destination = "/tmp/provisioner.sh"
}

  provisioner "shell" {
    inline = ["chmod a+x /tmp/provisioner.sh"]
  }
  
  provisioner "shell" {
    inline = [ "ls -la /tmp"]
  }
  
    provisioner "shell" {
    inline = [ "pwd"]
  }
  
  provisioner "shell" {
    inline = [ "cat /tmp/provisioner.sh"]
  }

  provisioner "shell" {
    inline = ["/bin/bash -x /tmp/provisioner.sh"]
  }
}

