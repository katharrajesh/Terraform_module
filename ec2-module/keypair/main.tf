# Create key pair
resource "aws_key_pair" "tf-key-pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf-key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = var.key_name
  file_permission = "0600"
}