output "vpc_id" {
  description = "VPCのID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "パブリックサブネットのIDリスト"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "プライベートサブネットのIDリスト"
  value       = [for s in aws_subnet.private : s.id]
}
