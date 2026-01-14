output "control_plane_sg_id" {
  value = aws_security_group.control_plane.id
}

output "node_sg_id" {
  value = aws_security_group.nodes.id
}
