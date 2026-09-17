variable "vpc_cidr" {
  description = "vpc cidr range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "public subnet cidr range"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "private subnet cidr range"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "availability zone"
  type        = string
  default     = "us-east-1a"
}