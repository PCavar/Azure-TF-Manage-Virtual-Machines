variable "prefix" {
  default = "non-prod"
}

variable "region" {
  type        = string
  description = "Available regions for deployment"
  default     = "North Europe"
}

variable "virtual_network_one" {
  type        = string
  description = "CIDR for vnet one"
  default     = "10.80.0.0/20"
}

variable "virtual_network_two" {
  type        = string
  description = "CIDR for vnet two"
  default     = "10.82.0.0/20"
}

variable "subnet_one" {
  type        = string
  description = "CIDR for subnet one"
  default     = "10.80.0.0/24"
}

variable "subnet_two" {
  type        = string
  description = "CIDR for subnet two"
  default     = "10.82.0.0/24"
}


