#Permissions policy for the AWS Load Balancer Controller (from the official JSON)
resource "aws_iam_policy" "lbc" {
  name        = "${var.Deepan}-AWSLoadBalancerControllerIAMPolicy"
  description = "Permissions for the AWS Load Balancer Controller"
  policy      = file("${path.module}/lbc-iam-policy.json")
}

#IAM role for the Load Balancer Controller pod
resource "aws_iam_role" "lbc" {
  name = "${var.Deepan}-lbc-role"

  # Trust policy: EKS Pod Identity can assume this role on behalf of a pod
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name = "${var.Deepan}-lbc-role"
  }
}

#Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lbc" {
  role       = aws_iam_role.lbc.name
  policy_arn = aws_iam_policy.lbc.arn
}

#Pod Identity: give the LBC service account the LBC IAM role
resource "aws_eks_pod_identity_association" "lbc" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.lbc.arn
}