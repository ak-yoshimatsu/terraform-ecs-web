output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "ALBのDNS名"
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "ECRリポジトリURL"
}