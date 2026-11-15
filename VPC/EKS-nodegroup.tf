#EKS managed node group (worker nodes)
resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.Deepan}-ng-arm"
  node_role_arn   = aws_iam_role.eks-node-role.arn
  subnet_ids      = aws_subnet.private-subnet[*].id

  # Instance settings
  ami_type       = "AL2023_ARM_64_STANDARD"
  instance_types = ["t4g.large"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  # How many nodes
  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 4
  }

  # During upgrades, replace at most 1 node at a time
  update_config {
    max_unavailable = 1
  }

  # Let autoscalers change the node count without Terraform reverting it
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  # Nodes need their IAM permissions BEFORE they boot
  depends_on = [aws_iam_role_policy_attachment.eks-node-policies]

  tags = {
    Name = "${var.Deepan}-ng-arm"
  }
}