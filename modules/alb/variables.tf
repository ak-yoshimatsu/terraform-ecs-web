variable "project_name" {
  description = "プロジェクト名"
}

variable "vpc_id" {
  description = "VPCのID"
}

variable "public_subnet_ids" {
  description = "パブリックサブネットのIDリスト"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ALBのセキュリティグループID"
}
