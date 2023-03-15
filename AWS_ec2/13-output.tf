#######################################################################################
# EC2 Output
#######################################################################################

/* output "private_ips" {
  description = "Private IP"
  value       = [aws_instance.app_server.*.private_ip]
}

output "public_ips" {
  description = "Public IP"
  value       = [aws_instance.app_server.*.public_ip]
}

output "private_dns" {
  description = "Private DNS"
  value = [aws_instance.app_server.*.private_dns]
} */

#######################################################################################
# Application Load Balancer Output
#######################################################################################

output "alb_target_group_arn" {
  value = [aws_lb_target_group.alb_target_group.arn]
}

output "alb_load_balancer_dns" {
  value = [aws_lb.application_load_balancer.dns_name]
}

output "alb_load_balancer_zone_id" {
  value = [aws_lb.application_load_balancer.zone_id]
}

#######################################################################################
# Acm Certificate Output
#######################################################################################

output "acm_certificate_arn" {
  value = [aws_acm_certificate.acm_certificate.arn]
}

output "record_name" {
  value = [aws_route53_record.site_domain.fqdn]
}