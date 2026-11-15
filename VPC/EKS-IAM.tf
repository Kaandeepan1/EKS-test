#IAM role for the EKS control plane
resource "aws_iam_role" "eks-cluster-role" {
  name = "${var.Deepan}-eks-cluster-role"

  # Trust policy: only the EKS service can assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name = "${var.Deepan}-eks-cluster-role"
  }
}

#Attach the AWS-managed EKS cluster policy
resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#IAM role for the EKS worker nodes
resource "aws_iam_role" "eks-node-role" {
  name = "${var.Deepan}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.Deepan}-eks-node-role"
  }
}
#Attach the policies the worker nodes need
resource "aws_iam_role_policy_attachment" "eks-node-policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ])

  role       = aws_iam_role.eks-node-role.name
  policy_arn = each.value
}