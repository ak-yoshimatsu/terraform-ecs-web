output "repository_url" {
  description = "ECRリポジトリのURL"
  value       = aws_ecr_repository.main.repository_url
}
