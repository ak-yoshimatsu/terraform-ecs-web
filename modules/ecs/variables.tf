variable "project_name" {
  description = "プロジェクト名"
}

variable "vpc_id" {
  description = "VPCのID"
}

variable "private_subnet_ids" {
  description = "プライベートサブネットのIDリスト"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "ECSタスクのセキュリティグループID"
}

variable "target_group_arn" {
  description = "ALBターゲットグループのARN"
}

variable "ecr_repository_url" {
  description = "ECRリポジトリのURL"
}
