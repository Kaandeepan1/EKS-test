#EKS cluster (control plane)
resource "aws_eks_cluster" "eks" {
  name     = "${var.Deepan}-eks"
  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = "1.37"


  # Who can talk to the Kubernetes API, and how
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # Which network the control plane connects into
  vpc_config {
    subnet_ids              = aws_subnet.private-subnet[*].id
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  # Make sure permissions exist before create, and are removed only after delete
  depends_on = [aws_iam_role_policy_attachment.eks-cluster-policy]

  tags = {
    Name = "${var.Deepan}-eks"
  }
}