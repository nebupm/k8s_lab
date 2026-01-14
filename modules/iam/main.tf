data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "k8s_node" {
  name               = "${var.name}-cluster-node-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Base permissions for nodes
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.k8s_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.k8s_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Instance profile
resource "aws_iam_instance_profile" "k8s_node" {
  name = "${var.name}-cluster-node-profile"
  role = aws_iam_role.k8s_node.name
}
