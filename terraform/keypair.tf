resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "camply_tf_key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.example.private_key_pem
  filename          = "${path.module}/my_key.pem"
  file_permission   = "0600"
}