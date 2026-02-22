variable "region" {
  description = "AWSリージョン"
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "プロジェクト名（リソース名のプレフィックスに使用）"
  default     = "terraform-ecs-fastapi"
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  default     = "10.0.0.0/16"
}
