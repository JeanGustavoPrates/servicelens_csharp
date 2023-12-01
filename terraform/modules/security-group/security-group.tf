resource "aws_security_group" "sg_csharp" {
  vpc_id = var.aws_vpc.id

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
