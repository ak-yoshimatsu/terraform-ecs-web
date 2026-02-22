output "alb_sg_id" {
  description = "ALBのセキュリティグループID"
  value       = aws_security_group.alb.id
}

output "ecs_sg_id" {
  description = "ECSタスクのセキュリティグループID"
  value       = aws_security_group.ecs.id
}
