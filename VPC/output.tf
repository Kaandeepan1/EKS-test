output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.Deepan-1.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs (ALB, NAT)"
  value       = aws_subnet.public-subnet[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs (EKS worker nodes)"
  value       = aws_subnet.private-subnet[*].id
}

output "nat_gateway_public_ip" {
  description = "Public IP that private subnets use to reach the internet"
  value       = aws_eip.nat-eip.public_ip
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_node_group_name" {
  value = aws_eks_node_group.nodes.node_group_name
}
