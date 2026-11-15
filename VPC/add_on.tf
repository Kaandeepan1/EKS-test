#EKS Pod Identity Agent - lets pods get their own IAM roles
resource "aws_eks_addon" "pod-identity-agent" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "eks-pod-identity-agent"

  depends_on = [aws_eks_node_group.nodes]
}