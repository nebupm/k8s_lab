resource "aws_security_group" "control_plane" {
  name        = "${var.name}-control-plane-sg"
  description = "Kubernetes control plane SG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-control-plane"
  }
}

resource "aws_security_group_rule" "ssh_control_plane" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.control_plane.id
  cidr_blocks       = var.allowed_ssh_cidr
}

# API Server access (nodes → control plane)
resource "aws_security_group_rule" "apiserver" {
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.nodes.id
}

# kubelet access (control plane → nodes)
resource "aws_security_group_rule" "kubelet" {
  type                     = "egress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.nodes.id
}

resource "aws_security_group" "nodes" {
  name        = "${var.name}-node-sg"
  description = "Kubernetes worker nodes SG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-nodes"
  }
}

# kubelet API (control plane → nodes)
resource "aws_security_group_rule" "nodes_kubelet" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nodes.id
  source_security_group_id = aws_security_group.control_plane.id
}

# NodePort services
resource "aws_security_group_rule" "nodeport" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes.id
  cidr_blocks       = ["0.0.0.0/0"] # tighten later
}

# Pod-to-pod traffic (CNI)
resource "aws_security_group_rule" "pod_traffic" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nodes.id
  self              = true
}

resource "aws_security_group_rule" "ssh_nodes" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes.id
  cidr_blocks       = var.allowed_ssh_cidr
}
