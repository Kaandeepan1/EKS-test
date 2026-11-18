variable "Deepan" {
  description = "Tagging name to use-my own name"
  type        = string
  default     = "test"
}

variable "VPC-cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public-subnet" {
  description = "public subnet CIDR block"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private-subnet" {
  description = "creating two private subnet"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "cluster_admin_username" {
  description = "IAM user who gets admin access to the EKS cluster"
  type        = string
  default     = "your-iam-username"
}