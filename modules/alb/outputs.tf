output "alb_dns_name" {
  description = "ALBのDNS名"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "ターゲットグループのARN"
  value       = aws_lb_target_group.main.arn
}
