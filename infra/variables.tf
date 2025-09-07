variable "region" {
  type    = string
  default = "us-east-1"
}
variable "project_name" {
  type    = string
  default = "tangled-web-lab"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "owner" {
  type    = string
  default = "you"
}

variable "container_port" {
  type    = number
  default = 3000
}
variable "desired_count" {
  type    = number
  default = 1
}
variable "cpu" {
  type    = number
  default = 256
} # 0.25 vCPU
variable "memory" {
  type    = number
  default = 512
} # 0.5 GB

# Filled by CI when retagging to your ECR; default keeps it easy for manual apply.
variable "image_uri" {
  type    = string
  default = "bkimminich/juice-shop:latest"
}
