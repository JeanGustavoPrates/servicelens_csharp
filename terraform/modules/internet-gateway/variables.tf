variable "aws_vpc" {
    default = ""
}

variable "csharp_subnet_1" {
    default = ""
}

variable "csharp_subnet_2" {
    default = ""
}

variable "public_route_destinations" {
  type    = list(string)
  default = []
}