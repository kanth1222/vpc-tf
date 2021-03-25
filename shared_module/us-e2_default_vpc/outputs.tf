output "transit_gateway" {
  value = data.aws_ec2_transit_gateway.main.id
}

output "association_proposal_id" {
  value = aws_dx_gateway_association_proposal.main.id
}
