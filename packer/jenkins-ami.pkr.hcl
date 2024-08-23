packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "source_ami" {
  type    = string
  default = "ami-04b70fa74e45c3917"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}


variable "GH_USERNAME" {
  type    = string
  default = ""
}

variable "GH_CREDS" {
  type    = string
  default = ""
}

variable "DOCKERHUB_USERNAME" {
  type    = string
  default = ""
}

variable "DOCKERHUB_CREDS" {
  type    = string
  default = ""
}

source "amazon-ebs" "jenkins-ami" {
  region        = var.region
  source_ami    = var.source_ami
  instance_type = var.instance_type
  ssh_username  = var.ssh_username
  ami_name      = "jenkins-{{timestamp}}"
  tags = {
    Name = "Peizhen-Jenkins - {{timestamp}}"
  }
  vpc_id    = "vpc-023f27855f38a83dd"
  subnet_id = "subnet-06242053329a9c97d"
}

build {
  sources = ["sources.amazon-ebs.jenkins-ami"]

  provisioner "file" {
    source      = "jenkins/install-jenkins.sh"
    destination = "/tmp/install-jenkins.sh"
  }

  provisioner "file" {
    source      = "jenkins/jenkins.conf"
    destination = "/tmp/jenkins.conf"
  }

  provisioner "file" {
    source      = "jenkins/plugins.txt"
    destination = "/tmp/plugins.txt"
  }

  provisioner "file" {
    source      = "jenkins/casc.yaml"
    destination = "/tmp/casc.yaml"
  }

  provisioner "file" {
    source      = "nginx/install-nginx.sh"
    destination = "/tmp/install-nginx.sh"
  }

  provisioner "file" {
    source      = "nginx/configure-nginx.sh"
    destination = "/tmp/configure-nginx.sh"
  }

  provisioner "file" {
    source      = "jenkins/dockerhubcreds.groovy"
    destination = "/tmp/dockerhubcreds.groovy"
  }
  provisioner "file" {
    source      = "jenkins/githubcredentials.groovy"
    destination = "/tmp/githubcredentials.groovy"
  }

  provisioner "file" {
    source      = "jenkins/job-dsl.groovy"
    destination = "/tmp/job-dsl.groovy"
  }

  provisioner "shell" {

    inline = [
      "echo 'GH_USERNAME=${var.GH_USERNAME}' | sudo tee -a /etc/jenkins.env",
      "echo 'GH_CREDS=${var.GH_CREDS}' | sudo tee -a /etc/jenkins.env",
      "echo 'DOCKERHUB_USERNAME=${var.DOCKERHUB_USERNAME}' | sudo tee -a /etc/jenkins.env",
      "echo 'DOCKERHUB_CREDS=${var.DOCKERHUB_CREDS}' | sudo tee -a /etc/jenkins.env",

      "echo 'Listing current subdirectories in /tmp:'",
      "ls -l /tmp",
      "sudo chmod +x /tmp/install-jenkins.sh /tmp/install-nginx.sh /tmp/configure-nginx.sh",
      "sudo /tmp/install-jenkins.sh",
      "sudo /tmp/install-nginx.sh",
      "sudo /tmp/configure-nginx.sh",
    ]
  }
}
