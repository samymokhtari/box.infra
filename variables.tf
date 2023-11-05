variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Region GCP"
  default     = "europe-west1"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = "vpc"
}

variable "bucket_storage" {
  type        = string
  description = "Bucket Storage Name"
  default     = "box-files"
}

variable "compute_instance_name" {
  type        = string
  description = "Compute Instance Name"
  default     = "vm-sql"
}

variable "ssh_user" {
  type        = string
  description = "SSH User"
}


variable "ssh_public_key" {
  type        = string
  description = "SSH Public Key"
}