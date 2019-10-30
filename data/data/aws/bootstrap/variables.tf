variable "ami" {
  type        = string
  description = "The AMI ID for the bootstrap node."
}

variable "cluster_id" {
  type        = string
  description = "The identifier for the cluster."
}

variable "etcd_count" {
  description = "The number of etcd members."
  type        = string
}

variable "etcd_ip_addresses" {
  description = "List of string IPs for machines running etcd members."
  type        = list(string)
  default     = []
}

variable "ignition" {
  type        = string
  description = "The content of the bootstrap ignition file."
}

variable "instance_type" {
  type        = string
  description = "The instance type of the bootstrap node."
}

variable "internal_hosted_zone" {
  type        = string
  description = "The ID of the internal Route 53 hosted zone."
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID for the bootstrap node."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS tags to be applied to created resources."
}

variable "target_group_arns" {
  type        = list(string)
  default     = []
  description = "The list of target group ARNs for the load balancer."
}

variable "target_group_arns_length" {
  description = "The length of the 'target_group_arns' variable, to work around https://github.com/hashicorp/terraform/issues/12570."
}

variable "volume_iops" {
  type        = string
  default     = "100"
  description = "The amount of IOPS to provision for the disk."
}

variable "volume_size" {
  type        = string
  default     = "30"
  description = "The volume size (in gibibytes) for the bootstrap node's root volume."
}

variable "volume_type" {
  type        = string
  default     = "gp2"
  description = "The volume type for the bootstrap node's root volume."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID is used to create resources like security group rules for bootstrap machine."
}

variable "vpc_cidrs" {
  type        = list(string)
  default     = []
  description = "VPC CIDR blocks."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  default     = []
  description = "VPC security group IDs for the bootstrap node."
}

variable "publish_strategy" {
  type        = string
  description = "The publishing strategy for endpoints like load balancers"
}
