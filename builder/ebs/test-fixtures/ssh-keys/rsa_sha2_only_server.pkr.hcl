/*
OpenSSH migrated the ssh-rsa key type, which historically used the ssh-rsa
signature algorithm based on SHA-1, to the new rsa-sha2-256 and rsa-sha2-512 signature algorithms.

Golang issues: https://github.com/golang/go/issues/49952

See plugin issue: https://github.com/hashicorp/packer-plugin-amazon/issues/213
*/

data "amazon-ami" "autogenerated_1" {
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "us-east-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "basic-example" {
  ami_description = "Ubuntu 22.04 GoldenImage"
  ami_name        = "ubuntu-22.04-${local.timestamp}"
  instance_type   = "t3.micro"
  region          = "us-east-1"
  source_ami      = "${data.amazon-ami.autogenerated_1.id}"
  ssh_username    = "ubuntu"
  skip_create_ami = true
}

build {
  sources = ["source.amazon-ebs.basic-example"]

  provisioner "shell" {
    inline = ["echo Successful login"]
  }

}
