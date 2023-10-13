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
  source_ami                  = "ami-0aec300fa613b1c92"
  ssh_username                = "ec2-user"
  associate_public_ip_address = true
  subnet_id                   = "subnet-00886041eab1646d2"
  security_group_id           = "sg-036620696910fdd53" 
  ami_regions = [
    "us-east-2"
  ]
}

// build {
//   name = "hq-packer"
//   sources = [
//     "amazon-ebs.Amazon_ami_image"
//   ]
//   provisioner "ansible" {
//     playbook_file = "AmznLinux2_playbook.yml"
//   }
// }

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

